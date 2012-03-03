# -*- coding: utf-8 -*-
require 'test/helper'

class DetectorTest < Test::Unit::TestCase
  TRAINING_EN = [0x0061, 0x0061, 0x0061, 0x0062, 0x0062, 0x0063, 0x0063, 0x0064, 0x0065]
  TRAINING_FR = [0x0061, 0x0062, 0x0062, 0x0063, 0x0063, 0x0063, 0x0063, 0x0064, 0x0064]
  TRAINING_JP = [0x3042, 0x3042, 0x3042, 0x3044, 0x3046, 0x3048, 0x3048]

  def setup
    @factory = DetectorFactory.new
    profile_en = LangProfile.new("en")
    TRAINING_EN.each do |w|
      profile_en.add([w])
    end
    @factory.add_profile(profile_en)

    profile_fr = LangProfile.new("fr")
    TRAINING_FR.each do |w|
      profile_fr.add([w])
    end
    @factory.add_profile(profile_fr)

    profile_jp = LangProfile.new("jp")
    TRAINING_JP.each do |w|
      profile_jp.add([w])
    end
    @factory.add_profile(profile_jp)
  end

  def test_detector1
    detector = @factory.create()
    detector.append([0x0061]) # "a"
    assert_equal("en", detector.detect())
  end

  def test_detector2
    detector = @factory.create()
    detector.append([0x0062, 0x0020, 0x0064]) # "b d"
    assert_equal("fr", detector.detect())
  end

  def test_detector3
    detector = @factory.create()
    detector.append([0x0064, 0x0020, 0x0065]) # "d e"
    assert_equal("en", detector.detect())
  end
  
  def test_detector4
    detector = @factory.create()
    detector.append([0x3042, 0x3042, 0x3042, 0x3042, 0x0061])
    assert_equal("jp", detector.detect())
  end

  def test_exceptions
    detector = @factory.create()
    detector.append([])
    assert_raises(NoFeaturesInTextError) do
      detector.detect()
    end
  end
end
