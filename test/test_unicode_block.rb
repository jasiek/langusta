require 'test/helper'

class UnicodeBlockTest < Test::Unit::TestCase
  def test_upper_case
    ["\x00\x47", "\x01\x10", "\x01\x64", "\x03\xd5", "\x04\xa2", "\x10\xc3", "\x21\x60", "\xa7\x60"].each do |cp|
      assert(Langusta::UnicodeBlock.is_upper_case?(cp))
    end
  end
end
