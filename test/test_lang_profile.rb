# -*- coding: utf-8 -*-
require 'test/helper'

class LangProfileTest < Test::Unit::TestCase
  def test_lang_profile
    assert_raises(ArgumentError) do
      LangProfile.new
    end
    assert_raises(TypeError) do
      LangProfile.new(nil)
    end
  end

  def test_lang_profile_string_int
    profile = LangProfile.new('en')
    assert_equal('en', profile.name)
  end

  def test_add
    profile = LangProfile.new('en')
    profile.add(utf82cp("a"))
    assert_equal(1, profile.freq[utf82cp("a")])
    profile.add(utf82cp("a"))
    assert_equal(2, profile.freq[utf82cp("a")])
    profile.omit_less_freq()
  end

  def test_add_illegally_1
    profile = LangProfile.new('sample')
    profile.add(utf82cp("a"))
    assert_equal(1, profile.freq[utf82cp("a")])
  end

  def test_add_illegally_2
    profile = LangProfile.new('en')
    profile.add(utf82cp("a"))
    profile.add(utf82cp(""))
    profile.add(utf82cp("abcd"))
    assert_equal(1, profile.freq[utf82cp("a")])
    assert_nil(profile.freq[utf82cp("")])
    assert_nil(profile.freq[utf82cp("abcd")])
  end

  def test_omit_less_freq
    profile = LangProfile.new('en')
    grams = [0x0061, 0x0062, 0x0063, 0x3042, 0x3044, 0x3046, 0x3048,
             0x304a, 0x304b, 0x304c, 0x304d, 0x304e, 0x304f]
    5.times do
      grams.each do |gram|
        profile.add([gram])
      end
    end
    profile.add([0x3050])

    assert_equal(5, profile.freq[utf82cp("a")])
    assert_equal(5, profile.freq[[0x3042]])
    assert_equal(1, profile.freq[[0x3050]])

    profile.omit_less_freq()

    assert_nil(profile.freq[utf82cp("a")])
    assert_equal(5, profile.freq[[0x3042]])
    assert_nil(profile.freq[[0x3050]])
  end

  def test_omit_less_freq_illegally
    profile = LangProfile.new('sample')
    assert_nil(profile.omit_less_freq())
  end

  def test_load_from_file
    Dir[File.join(PROFILES_PATH, '*')].each do |filename|
      profile = LangProfile.load_from_file(filename)
      assert_equal(filename.split(/\//).last, profile.name)
      has_content = [
       profile.freq[utf82cp(" A")], # Latin
       profile.freq[[0x060c]], # Arabic
       profile.freq[[0x0a85]], # Gujarati
       profile.freq[[0x0905]], # Hindi
       profile.freq[[0x3001]], # Japanese
      ].any?
      assert(has_content, profile.inspect)
    end
  end
end
