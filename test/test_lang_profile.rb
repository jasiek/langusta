# -*- coding: utf-8 -*-
require 'test/helper'

class LangProfileTest < Test::Unit::TestCase
  def test_lang_profile
    profile = LangProfile.new
    assert_nil(profile.name)
  end

  def test_lang_profile_string_int
    profile = LangProfile.new('en')
    assert_equal('en', profile.name)
  end

  def test_add
    profile = LangProfile.new('en')
    profile.add(UCS2String.from_utf8("a"))
    assert_equal(1, profile.freq[UCS2String.from_utf8("a")])
    profile.add(UCS2String.from_utf8("a"))
    assert_equal(2, profile.freq[UCS2String.from_utf8("a")])
    profile.omit_less_freq()
  end

  def test_add_illegally_1
    profile = LangProfile.new
    profile.add(UCS2String.from_utf8("a"))
    assert_nil(profile.freq[UCS2String.from_utf8("a")])
  end

  def test_add_illegally_2
    profile = LangProfile.new('en')
    profile.add(UCS2String.from_utf8("a"))
    profile.add(UCS2String.from_utf8(""))
    profile.add(UCS2String.from_utf8("abcd"))
    assert_equal(1, profile.freq[UCS2String.from_utf8("a")])
    assert_nil(profile.freq[UCS2String.from_utf8("")])
    assert_nil(profile.freq[UCS2String.from_utf8("abcd")])
  end

  def test_omit_less_freq
    profile = LangProfile.new('en')
    grams = "\x00a \x00b \x00c \x30\x42 \x30\x44 \x30\x46 \x30\x48 \x30\x4a \x30\x4b \x30\x4c \x30\x4d \x30\x4e \x30\x4f".split(/ /)
    5.times do
      grams.each do |gram|
        profile.add(UCS2String.new(gram))
      end
    end
    profile.add(UCS2String.new("\x30\x50"))

    assert_equal(5, profile.freq[UCS2String.from_utf8("a")])
    assert_equal(5, profile.freq[UCS2String.new("\x30\x42")])
    assert_equal(1, profile.freq[UCS2String.new("\x30\x50")])

    profile.omit_less_freq()
    assert_nil(profile.freq[UCS2String.from_utf8("a")])
    assert_equal(5, profile.freq[UCS2String.new("\x30\x42")])
    assert_nil(profile.freq[UCS2String.new("\x30\x50")])
  end

  def test_omit_less_freq_illegally
    profile = LangProfile.new
    profile.omit_less_freq()
  end

  def test_load_from_file
    Dir['profiles/*'].each do |filename|
      profile = LangProfile.load_from_file(filename)
      assert_equal(filename.split(/\//)[1], profile.name)
      has_content = [
       profile.freq[UCS2String.from_utf8(" A")], # Latin
       profile.freq[UCS2String.new("\x06\x0c")], # Arabic
       profile.freq[UCS2String.new("\x0a\x85")], # Gujarati
       profile.freq[UCS2String.new("\x09\x05")], # Hindi
       profile.freq[UCS2String.new("\x30\x01")], # Japanese
      ].any?
      assert(has_content, profile.inspect)
    end
  end
end
