# -*- coding: utf-8 -*-
require 'test/helper'

class JavaPropertyReaderTest < Test::Unit::TestCase
  def test_parse
    jpr = JavaPropertyReader.new(MESSAGES_PROPERTIES)
    assert_equal([0x4f7c, 0x6934], jpr["NGram.KANJI_1_0"])
  end
end
