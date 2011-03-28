module Langusta
  class Detector
    attr_accessor :verbose, :alpha, :max_text_length

    ALPHA_DEFAULT = 0.5
    ALPHA_WIDTH = 0.05
    ITERATION_LIMIT = 1000
    PROB_THRESHOLD = 0.1
    CONV_THRESHOLD = 0.99999
    BASE_FREQ = 10000
    UNKNOWN_LANG = "unknown"

    URL_REGEX = Oniguruma::ORegexp.new("https?://[-_.?&~;+=/#0-9A-Za-z]+", :encoding => Oniguruma::ENCODING_UTF16_BE)
    MAIL_REGEX = Oniguruma::ORegexp.new("[-_.0-9A-Za-z]+@[-_0-9A-Za-z]+[-_.0-9A-Za-z]+", :encoding => Oniguruma::ENCODING_UTF16_BE)
    
    def initialize(factory)
      @word_lang_prob_map = factory.word_lang_prob_map
      @lang_list = factory.lang_list
      @text = UCS2String.new('')
      @langprob = nil
      @alpha = ALPHA_DEFAULT
      @n_trial = 7
      @max_text_length = 10000
      @prior_map = nil
      @verbose = false
    end

    def append(text)
      text.gsub!(URL_REGEX, "\x00\x20")
      text.gsub!(MAIL_REGEX, "\x00\x20")
      text.each_char do |c|
        NGram.normalize(c)
      end
      @text = text.gsub!(Oniguruma::ORegexp.new("(\x00\x20)*", :encoding => Oniguruma::ENCODING_UTF16_BE), "\x00\x20")
    end

    def detect
      probabilities = get_probabilities()
      (probabilities.length > 0) ? probabilities.first.lang : UNKNOWN_LANG
    end

    def detect_block
      cleaning_text()
      ngrams = extract_ngrams()
      raise "no features in text" if ngrams.empty?
      langprob = Array.new(@lang_list.length)

      n_trial.times do
        prob = init_probability()
        alpha = @alpha + next_gaussian() * ALPHA_WIDTH
        
        i = 0
        Kernel.loop do
          r = Kernel.rand(ngrams.length)
          update_lang_prob(prob, ngrams.get(r), alpha)
          if i % 5
            break if normalize_prob(prob) > CONV_THRESHOLD || i >= ITERATION_LIMIT
            # verbose
          end
        end
        langprob.length.times do |j|
          langprob[j] += prob[j] / n_trial
        end
        # verbose
      end
    end

    def set_prior_map(prior_map)
      @prior_map = Array.new[@lang_list.length]
      sump = 0.0
      @prior_map.length.times do |i|
        lang = @lang_list[i]
        if @prior_map.has_key?(lang)
          p = @prior_map[lang]
          raise "probability must be non-negative" if p < 0
          @prior_map[i] = p
          sump += p
        end
      end
      raise "more one of prob must be non-zero" if sump <= 0
      @prior_map.map! do |p|
        p /= sump
      end
    end

    def self.normalize_prob(prob)
      maxp = 0.0; sump = 0.0
      prob.each do |p|
        sump += p
      end
      prob.map! do |p|
        q = p / sump
        maxp = q if q > maxp
        q
      end
      maxp
    end

    private
    def cleaning_text
      non_latin_count = latin_count = 0
      @text.each_char do |c|
        if c < "\00z" && c >= "\x00A"
          latin_count += 1
        elsif c > "\x03\x00" && UnicodeBlock.of(c) != UnicodeBlock::LATIN_EXTENDED_ADDITIONAL
          non_latin_count += 1
        end
      end
      if latin_count * 2 < non_latin_count
        text_without_latin = StringIO.new
        @text.each_char do |c|
          text_without_latin << c if c > "\x00z" || c < "\x00A"
        end
        @text = text_without_latin.to_s
      end
    end

    def extract_ngrams
      list = []
      ngram = NGram.new
      @text.each_char do |char|
        ngram.add(char)
        (1..NGram.N_GRAM).each do |n|
          w = ngram.get(n)
          list << w if w && @word_lang_prob_map.has_key?(w)
        end
      end
      list
    end

    def get_probabilities
      if @langprob.nil?
        detect_block()
      end
      sort_probability(@langprob)
      @langprob
    end

    def init_probability
      prob = Array.new(@lang_list.length)
      if @prior_map
        prob = @prior_map.clone
      else
        prob.length.times do |i|
          prob[i] = 1.0 / @lang_list.length
        end
      end
      prob
    end

    def sort_probability(prob)
      list = prob.zip(@lang_list)
      list.sort_by! do |x|
        x[0]
      end
      list.select! do |x|
        x[0] > PROB_THRESHOLD
      end
      list.map do |x|
        x[1]
      end
    end

    def update_lang_prob(prob, word, alpha)
      return false if word.nil? || ! @word_lang_prob_map.has_key?(word)

      lang_prob_map = @word_lang_prob_map[word]
      # verbose
      weight = alpha / BASE_FREQ
      prob.length.times do |i|
        prob[i] *= weight + lang_prob_map[i]
      end
      true
    end

    def word_prob_to_string(prob)
      prob.zip(@lang_list).select do |p, lang|
        p > 0.00001
      end.map do |p, lang|
        "%s:%.5f" % [p, lang]
      end.join(' ')
    end
  end
end
