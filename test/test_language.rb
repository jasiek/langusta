# -*- coding: utf-8 -*-
require 'test/helper'

class LanguageTest < Test::Unit::TestCase
  def test_language
    lang = Language.new(nil, 0)
    assert_nil(lang.lang)
    assert_in_delta(0, lang.prob, 0.0001)
    assert_equal('', lang.to_s)

    lang = Language.new('en', 1.0)
    assert_equal('en', lang.lang)
    assert_in_delta(1, lang.prob, 0.0001)
    assert_equal('en:1.0', lang.to_s)
  end
end
