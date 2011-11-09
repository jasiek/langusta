# -*- coding: utf-8 -*-
require 'test/helper'

class UCS2StringTest < Test::Unit::TestCase
  include Langusta

  def test_invalid_unicode_sequences_raise_an_error
    assert_raises(Iconv::IllegalSequence) do
      UCS2String.from_utf8("\xc0")
    end
  end

  def test_chooses_right_implementation
    if RUBY_VERSION < "1.9"
      assert_equal(UCS2String::Converter, UCS2String::Ruby18Converter)
    else
      assert_equal(UCS2String::Converter, UCS2String::Ruby19Converter)
    end
  end

  def test_convert_to_ucs2_string
    assert_equal("\x00a", UCS2String::Converter.to_ucs2_string('a'))
    assert_equal("\x00z\x00a\x01\x7c\x00\xf3\x01\x42\x01\x07\x00\x20\x00\x67\x01\x19\x01\x5b\x00\x6c\x01\x05\x00\x20\x00\x6a\x00\x61\x01\x7a\x01\x44", UCS2String::Converter.to_ucs2_string('zażółć gęślą jaźń'))
  end
end
