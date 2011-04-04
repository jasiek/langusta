require 'test/helper'

class DetectorFactoryTest < Test::Unit::TestCase
  def test_add_profile
    profile = LangProfile.new
    factory = DetectorFactory.new

    factory.add_profile(profile, 0, 1)
    assert_raises(LangDetectException) do
      factory.add_profile(profile, 1, 1)
    end
    
    detector = factory.create(0.123)
    assert_equal(0.123, detector.alpha)
  end
end
