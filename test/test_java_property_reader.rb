# -*- coding: utf-8 -*-
require 'test/helper'

class JavaPropertyReaderTest < Test::Unit::TestCase
  def test_parse
    jpr = JavaPropertyReader.new(MESSAGES_PROPERTIES)
    assert_equal("\x4f\x7c\x69\x34", jpr["NGram.KANJI_1_0"])
  end
end
