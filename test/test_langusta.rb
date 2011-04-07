require 'test/helper'

class LangustaTest < Test::Unit::TestCase

  FACTORY = DetectorFactory.new
  profiles = Dir[File.join(PROFILES_PATH, '*')].map do |filename|
    LangProfile.load_from_file(filename)
  end
  profiles.each_with_index do |profile, index|
    FACTORY.add_profile(profile, index, profiles.length)
  end

  Dir['test/test_data/*'].each do |filename|
    language = filename.split(/\//).last
    define_method(("test_%s_language" % [language]).to_sym) do 
      detector = FACTORY.create
      
      ucs2_content = UCS2String.from_utf8(File.open(filename).read)
      detector = FACTORY.create
      detector.append(ucs2_content)
      
      assert_equal(language, detector.detect)
    end
  end
end
