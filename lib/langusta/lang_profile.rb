require 'set'

module Langusta
  class LangProfile
    MINIMUM_FREQ = 2
    LESS_FREQ_RATIO = 100_000
    attr_reader :name, :freq, :n_words

    # Constructs a language profile from a file. Converts all NGrams from UTF-8 to Unicode codepoints.
    # @param [String] file name of the language profile.
    # @return [LangProfile]
    def self.load_from_file(filename)
      json = Yajl::Parser.parse(File.new(filename))

      freq = json['freq'].inject({}) do |acc, kv|
        key, value = kv
        acc[Langusta.utf82cp(key)] = value
        acc
      end

      self.new(json['name'] || (raise CorruptProfileError.new("Missing profile name")),
               freq,
               json['n_words'] || (raise CorruptProfileError.new("Missing number of words value")))
    end

    def initialize(name, freq={}, n_words = Array.new(NGram::N_GRAM, 0))
      Guard.klass(name, String, __method__)
      @name, @freq, @n_words = name, freq, n_words
    end

    # Adds a given NGram to this language profile. This operation is expected to be invoked multiple times for the same arguments.
    # @param gram [Array<Fixnum>]
    def add(gram)
      return if gram.nil?
      Guard.klass(gram, Array, __method__)

      length = gram.size
      return if length < 1 or length > NGram::N_GRAM
      @n_words[length - 1] += 1
      @freq[gram] ||= 0
      @freq[gram] += 1
    end

    def omit_less_freq
      threshold = @n_words[0] / LESS_FREQ_RATIO
      threshold = MINIMUM_FREQ if threshold < MINIMUM_FREQ
      keys = Set.new(@freq.keys)
      roman = 0
      keys.each do |key|
        count = @freq[key]
        if count <= threshold
          @n_words[key.size - 1] -= count
          @freq.delete(key)
        else
          # temp workaround
          if RegexHelper::ROMAN_REGEX.match(Langusta.cp2utf8(key))
            roman += count
          end
        end
      end

      if roman < @n_words[0] / 3
        keys2 = Set.new(@freq.keys)
        keys2.each do |key|
          # temp workaround
          if RegexHelper::INCL_ROMAN_REGEX.match(Langusta.cp2utf8(key))
            @n_words[key.size - 1] -= @freq[key]
            @freq.delete(key)
          end
        end
      end
    end
  end
end
