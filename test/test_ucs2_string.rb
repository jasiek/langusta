require 'test/helper'

class UCS2StringTest < Test::Unit::TestCase
  def test_invalid_unicode_sequences_raise_an_error
    assert_raises(Iconv::IllegalSequence) do
      UCS2String.from_utf8("\xc0")
    end
  end
end
