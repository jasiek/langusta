module Langusta
  class LanguageDetectionFacade
    def initialize
      @factory = DetectorFactory.new
      profiles = load_profiles()
      profiles.each do |profile|
        @factory.add_profile(profile)
      end
    end

    def detect(utf8_string)
      detector = @factory.create()
      detector.append(Langusta.utf82cp(utf8_string))
      detector.detect()
    end

    private
    def load_profiles
      Dir[File.join(PROFILES_PATH, '/*')].map do |filename|
        LangProfile.load_from_file(filename)
      end
    end
  end
end
