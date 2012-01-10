# -*- coding: utf-8 -*-
require 'test/helper'

class TagExtractorTest < Test::Unit::TestCase
  def test_tag_extractor
    extractor = TagExtractor.new(nil, 0)
    assert_nil(extractor.target)
    assert_equal(0, extractor.threshold)

    extractor2 = TagExtractor.new(str2cp("abstract"), 10)
    assert_equal(str2cp("abstract"), extractor2.target)
    assert_equal(10, extractor2.threshold)
  end

  def test_set_tag
    extractor = TagExtractor.new(nil, 0)
    extractor.tag = str2cp("")
    assert_equal(str2cp(""), extractor.tag)
    extractor.tag = nil
    assert_nil(extractor.tag)
  end

  def test_add
    extractor = TagExtractor.new(nil, 0)
    extractor.add(str2cp(""))
    extractor.add(nil)
  end

  def test_close_tag
    extractor = TagExtractor.new(nil, 0)
    profile = nil
    extractor.close_tag(profile)
  end

  def test_normal_scenario
    extractor = TagExtractor.new(str2cp("abstract"), 10)
    assert_equal(0, extractor.count)
    
    profile = LangProfile.new("en")
    # normal
    extractor.tag = str2cp("abstract")
    extractor.add(str2cp("This is a sample text."))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)
    assert_equal(17, profile.n_words[0])
    assert_equal(22, profile.n_words[1])
    assert_equal(17, profile.n_words[2])

    # too short
    extractor.tag = str2cp("abstract")
    extractor.add(str2cp("sample"))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)

    # other tags
    extractor.tag = str2cp("div")
    extractor.add(str2cp("This is a sample text which is enough long."))
    extractor.close_tag(profile)
    assert_equal(1, extractor.count)
  end

  def test_clear
    extractor = TagExtractor.new(str2cp("abstract"), 10)
    extractor.tag = str2cp("abstract")
    extractor.add(str2cp("This is a sample text."))
    assert_equal(str2cp("This is a sample text."), extractor.buffer)
    assert_equal(str2cp("abstract"), extractor.tag)
    extractor.clear
    assert_equal(str2cp(""), extractor.buffer)
    assert_nil(extractor.tag)
  end

  # All strings in this file are ASCII strings
  def str2cp(ascii_string)
    Iconv.conv('ucs-2be', 'ascii', ascii_string).unpack('n*')
  end
end
