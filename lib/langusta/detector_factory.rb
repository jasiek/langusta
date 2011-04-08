module Langusta
  class LangDetectException < StandardError; end

  class DetectorFactory
    attr_reader :word_lang_prob_map, :lang_list

    def initialize
      @word_lang_prob_map = {}
      @lang_list = []
    end

    # Adds a new language profile to this factory.
    # @param [LangProfile] language profile to be added.
    # @param [Fixnum] index at which the language profile is to be added.
    # @param [Fixnum] counts how many language profiles are to be added to this factory in total.
    def add_profile(profile, index, langsize)
      raise LangDetectException.new("duplicate the same language profile") if @lang_list.include?(profile.name)
      @lang_list << profile.name
      profile.freq.keys.each do |word|
        if not @word_lang_prob_map.has_key?(word)
          @word_lang_prob_map[word] = Array.new(langsize, 0.0)
        end
        prob = 1.0 * profile.freq[word] / profile.n_words[word.length - 1]
        @word_lang_prob_map[word][index] = prob
      end
    end

    # Creates a new detector object, based on a preconfigured set of language profiles.
    # @return [Detector]
    def create(alpha=nil)
      if alpha
        detector = create_detector()
        detector.alpha = alpha
        detector
      else
        create_detector()
      end
    end

    private
    def create_detector
      raise LangDetectException.new("need to load profiles") if @lang_list.length == 0
      detector = Detector.new(self)
    end
  end
end
