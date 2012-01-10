# -*- coding: utf-8 -*-
require 'test/helper'

class UnicodeBlockTest < Test::Unit::TestCase
  def test_upper_case
    [0x0047, 0x0110, 0x0164, 0x03d5, 0x04a2, 0x10c3, 0x2160, 0xa760].each do |cp|
      assert(Langusta::UnicodeBlock.is_upper_case?(cp))
    end
  end
end
