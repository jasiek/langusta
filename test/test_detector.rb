require 'test/helper'

class DetectorTest < Test::Unit::TestCase
  TRAINING_EN = "\x00a \x00a \x00a \x00b \x00b \x00c \x00c \x00d \x00e"
  TRAINING_FR = "\x00a \x00b \x00b \x00c \x00c \x00c \x00d \x00d \x00d"
  TRAINING_JP = "\x30\x42 \x30\x42 \x30\x42 \x30\x44 \x30\x46 \x30\x48 \x30\x48"

  def setup
    @factory = DetectorFactory.new
    profile_en = LangProfile.new("en")
    TRAINING_EN.split(/ /).each do |w|
      profile_en.add(w)
    end
    @factory.add_profile(profile_en, 0, 3)

    profile_fr = LangProfile.new("fr")
    TRAINING_FR.split(/ /).each do |w|
      profile_fr.add(w)
    end
    @factory.add_profile(profile_fr, 1, 3)

    profile_jp = LangProfile.new("jp")
    TRAINING_JP.split(/ /).each do |w|
      profile_jp.add(w)
    end
    @factory.add_profile(profile_jp, 2, 3)
  end

  def test_detector1
    detector = @factory.create()
    detector.append(UCS2String.new("\x00a"))
    assert_equal("en", detector.detect())
  end

  def test_detector2
    detector = @factory.create()
    detector.append(UCS2String.new("\x00b\x00\x20\x00d"))
    assert_equal("fr", detector.detect())
  end

  def test_detector3
    detector = @factory.create()
    detector.append(UCS2String.new("\x30\x42\x30\x42\x30\x42\x40\x42\x00a"))
    assert_equal("jp", detector.detect())
  end
end
