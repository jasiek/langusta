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
    profile.add(UCS2String.new("\x00a"))
    assert_equal(1, profile.freq[UCS2String.new("\x00a")])
    profile.add(UCS2String.new("\x00a"))
    assert_equal(2, profile.freq[UCS2String.new("\x00a")])
    profile.omit_less_freq()
  end

  def test_add_illegally_1
    profile = LangProfile.new
    profile.add(UCS2String.new("\x00a"))
    assert_nil(profile.freq[UCS2String.new("\x00a")])
  end

  def test_add_illegally_2
    profile = LangProfile.new('en')
    profile.add(UCS2String.new("\x00a"))
    profile.add(UCS2String.new(""))
    profile.add(UCS2String.new("\x00a\x00b\x00c\x00d"))
    assert_equal(1, profile.freq[UCS2String.new("\x00a")])
    assert_nil(profile.freq[UCS2String.new("")])
    assert_nil(profile.freq[UCS2String.new("\x00a\x00b\x00c\x00d")])
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

    assert_equal(5, profile.freq[UCS2String.new("\x00a")])
    assert_equal(5, profile.freq[UCS2String.new("\x30\x42")])
    assert_equal(1, profile.freq[UCS2String.new("\x30\x50")])

    profile.omit_less_freq()
    assert_nil(profile.freq[UCS2String.new("\x00a")])
    assert_equal(5, profile.freq[UCS2String.new("\x30\x42")])
    assert_nil(profile.freq[UCS2String.new("\x30\x50")])
  end

  def test_omit_less_freq_illegally
    profile = LangProfile.new
    profile.omit_less_freq()
  end
end
