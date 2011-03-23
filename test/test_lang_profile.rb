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
    profile.add('a')
    assert_equal(1, profile.freq['a'])
    profile.add('a')
    assert_equal(2, profile.freq['a'])
    profile.omit_less_freq()
  end

  def test_add_illegally_1
    profile = LangProfile.new
    profile.add('a')
    assert_nil(profile.freq['a'])
  end

  def test_add_illegally_2
    profile = LangProfile.new('en')
    profile.add('a')
    profile.add('')
    profile.add('abcd')
    assert_equal(1, profile.freq['a'])
    assert_nil(profile.freq[''])
    assert_nil(profile.freq['abcd'])
  end

  if RUBY_VERSION > "1.9.0"
    def test_omit_less_freq_ruby19
      profile = LangProfile.new('en')
      grams = "a b c \x30\x42 \x30\x44 \x30\x46 \x30\x48 \x30\x4a \x30\x4b \x30\x4c \x30\x4d \x30\x4e \x30\x4f".split(/ /)
      grams.each do |gram|
        profile.add(gram)
      end
      profile.add("\x30\x50")

      assert_equal(5, profile.freq['a'])
      assert_equal(5, profile.freq["\x30\x42"])
      assert_equal(1, profile.freq["\x30\x50"])
      profile.omit_less_freq()
      assert_nil(profile.freq['a'])
      assert_equal(5, profile.freq["\x30\x42"])
      assert_nil(profile.freq["\x30\x50"])
    end
  else
    def test_omit_less_freq_ruby18
      profile = LangProfile.new('en')
      grams = "a b c a b c ą ć ś ń ź ł".split(/ /)
      grams.each do |gram|
        profile.add(gram)
      end
      assert_equal(2, profile.freq['a'])
      assert_equal(2, profile.freq['b'])
      assert_equal(2, profile.freq['c'])
      assert_equal(1, profile.freq['ą'])
      profile.omit_less_freq()
      assert_nil(profile.freq['ą'])
    end
  end

  def test_omit_less_freq_illegally
    profile = LangProfile.new
    profile.omit_less_freq()
  end
end
