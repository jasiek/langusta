# -*- coding: utf-8 -*-
require 'test/helper'

class LangustaTest < Test::Unit::TestCase

  FACTORY = DetectorFactory.new

  Dir[File.join(PROFILES_PATH, '*')].each do |filename|
    profile = LangProfile.load_from_file(filename)
    FACTORY.add_profile(profile)
  end

  Dir['test/test_data/*'].each do |filename|
    language = filename.split(/\//).last
    define_method(("test_%s_language" % [language]).to_sym) do 
      detector = FACTORY.create
      
      ucs2_content = Langusta.utf82cp(File.open(filename).read)
      detector = FACTORY.create
      detector.append(ucs2_content)
      
      assert_equal(language, detector.detect)
    end
  end
end
