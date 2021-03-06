module Langusta
  class DetectorFactory
    include Inspector

    attr_reader :word_lang_prob_map, :lang_list

    def initialize
      @word_lang_prob_map = {}
      @lang_list = []
    end

    # Adds a new language profile to this factory.
    # @param [LangProfile] language profile to be added.
    # @param [Fixnum] index at which the language profile is to be added.
    # @param [Fixnum] counts how many language profiles are to be added to this factory in total.
    def add_profile(profile)
      raise DuplicateProfilesError.new(profile.name) if @lang_list.include?(profile.name)
      @lang_list << profile.name
      last_lang_index = @lang_list.size - 1

      profile.freq.keys.each do |word|
        @word_lang_prob_map[word] ||= []
        prob = 1.0 * profile.freq[word] / profile.n_words[word.length - 1]
        @word_lang_prob_map[word][last_lang_index] = prob
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

    def inspect
      "#<#{self.class.name}:0x#{object_ptr} (#{@lang_list.size} profile(s))"
    end

    private
    def create_detector
      raise NoProfilesLoadedError if @lang_list.empty?
      detector = Detector.new(self)
    end
  end
end
