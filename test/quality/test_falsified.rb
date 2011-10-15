require 'test/helper'

class FalsifiedTest < Test::Unit::TestCase
  ITERATIONS = 1_000

  def test_incorrect_guesses
    factory = DetectorFactory.new
    profiles = Dir[File.join(PROFILES_PATH, '*')].map do |filename|
      LangProfile.load_from_file(filename)
    end
    profiles.each do |profile|
      factory.add_profile(profile)
    end

    incorrect_guesses = 0.0

    ITERATIONS.times do
      Dir['test/test_data/*'].each do |filename|
        language = filename.split(/\//).last
        
        ucs2_content = UCS2String.from_utf8(File.open(filename).read)
        detector = factory.create
        detector.append(ucs2_content)
        
        incorrect_guesses += 1 if language != detector.detect
      end
    end

    puts
    puts "Accuracy: %s%%" % [100.0 - incorrect_guesses / Dir['test/test_data/*'].length / ITERATIONS]
    puts
  end
end
