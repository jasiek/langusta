require 'test/helper'

class TagExtractorTest < Test::Unit::TestCase
  def test_tag_extractor
    extractor = TagExtractor.new(nil, 0)
    assert_nil(extractor.target)
    assert_equal(0, extractor.threshold)

    extractor2 = TagExtractor.new(UCS2String.new("abstract"), 10)
    assert_equal(UCS2String.new("abstract"), extractor2.target)
    assert_equal(10, extractor2.threshold)
  end

  def test_set_tag
    extractor = TagExtractor.new(nil, 0)
    extractor.tag = UCS2String.new("")
    assert_equal(UCS2String.new(""), extractor.tag)
    extractor.tag = nil
    assert_nil(extractor.tag)
  end

  def test_add
    extractor = TagExtractor.new(nil, 0)
    extractor.add(UCS2String.new(""))
    extractor.add(nil)
  end

  def test_close_tag
    extractor = TagExtractor.new(nil, 0)
    profile = nil
    extractor.close_tag(profile)
  end

  def test_normal_scenario
    extractor = TagExtractor.new(UCS2String.new("abstract"), 10)
    assert_equal(0, extractor.count)
    
    profile = LangProfile.new("en")
    # normal
    extractor.tag = UCS2String.new("abstract")
    extractor.add(UCS2String.new("This is a sample text."))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)
    assert_equal(17, profile.n_words[0])
    assert_equal(22, profile.n_words[1])
    assert_equal(17, profile.n_words[2])

    # too short
    extractor.tag = UCS2String.new("abstract")
    extractor.add(UCS2String.new("sample"))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)

    # other tags
    extractor.tag = UCS2String.new("div")
    extractor.add(UCS2String.new("This is a sample text which is enough long."))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)
  end

  def test_clear
    extractor = TagExtractor.new(UCS2String.new("abstract"), 10)
    extractor.tag = UCS2String.new("abstract")
    extractor.add(UCS2String.new("This is a sample text."))
    assert_equal(UCS2String.new("This is a sample text."), extractor.buffer)
    assert_equal(UCS2String.new("abstract"), extractor.tag)
    extractor.clear
    assert_equal(UCS2String.new(""), extractor.buffer)
    assert_nil(extractor.tag)
  end
end
