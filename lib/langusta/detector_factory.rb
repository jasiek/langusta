module Langusta
  class LangDetectException < StandardError; end

  class DetectorFactory
    attr_reader :word_lang_prob_map, :lang_list

    def initialize
      @word_lang_prob_map = {}
      @lang_list = []
    end

    def add_profile(profile, index, langsize)
      raise LangDetectException.new("duplicate the same language profile") if @lang_list.include?(profile.name)
      @lang_list << profile.name
      profile.freq.keys.each do |word|
        if not @word_lang_prob_map.has_key?(word)
          @word_lang_prob_map[word] = Array.new(langsize)
        end
        prob = 1.0 * profile.freq[word] / profile.n_words[word.length - 1]
        @word_lang_prob_map[word][index] = prob
      end
    end

    def create(alpha=nil)
      if alpha
        detector = create_detector()
        detector.alpha = alpha
        detector
      else
        create_detector()
      end
    end

    def create_detector
      raise LangDetectException.new("need to load profiles") if @lang_list.length == 0
      detector = Detector.new(self)
    end
  end
end
