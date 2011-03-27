# -*- coding: utf-8 -*-
require 'test/helper'

class NGramTest < Test::Unit::TestCase
  def test_constants
    assert_equal(3, NGram::N_GRAM)
  end

  def test_normalize_with_latin
    assert_equal("\x00 ", NGram.normalize("\x00\x00")) # \0
    assert_equal("\x00 ", NGram.normalize("\x00\x09")) # <control>
    assert_equal("\x00 ", NGram.normalize("\x00\x20")) # space
    assert_equal("\x00 ", NGram.normalize("\x00\x30")) # 0
    assert_equal("\x00 ", NGram.normalize("\x00\x40")) # @
    assert_equal("\x00\x41", NGram.normalize("\x00\x41")) # A
    assert_equal("\x00\x5a", NGram.normalize("\x00\x5a")) # Z
    assert_equal("\x00 ", NGram.normalize("\x00\x5b")) # [
    assert_equal("\x00 ", NGram.normalize("\x00\x60")) # `
    assert_equal("\x00\x61", NGram.normalize("\x00\x61")) # a
    assert_equal("\x00\x7a", NGram.normalize("\x00\x7a")) # z
    assert_equal("\x00 ", NGram.normalize("\x00\x7b")) # {
    assert_equal("\x00 ", NGram.normalize("\x00\x7f")) # <control>
    assert_equal("\x00\x80", NGram.normalize("\x00\x80")) # <control>
    assert_equal("\x00 ", NGram.normalize("\x00\xa0")) # <control>
    assert_equal("\x00\xa1", NGram.normalize("\x00\xa1")) # <control>
  end

  def test_normalize_with_cjk_kanji
    assert_equal("\x4e\x00", NGram.normalize("\x4e\x00"))
    assert_equal("\x4e\x01", NGram.normalize("\x4e\x01"))
    assert_equal("\x4e\x02", NGram.normalize("\x4e\x02"))
    assert_equal("\x4e\x01", NGram.normalize("\x4e\x03"))
    assert_equal("\x4e\x04", NGram.normalize("\x4e\x04"))
    assert_equal("\x4e\x05", NGram.normalize("\x4e\x05"))
    assert_equal("\x4e\x06", NGram.normalize("\x4e\x06"))
    assert_equal("\x4e\x07", NGram.normalize("\x4e\x07"))
    assert_equal("\x4e\x08", NGram.normalize("\x4e\x08"))
    assert_equal("\x4e\x09", NGram.normalize("\x4e\x09"))
    assert_equal("\x4e\x10", NGram.normalize("\x4e\x10"))
    assert_equal("\x4e\x11", NGram.normalize("\x4e\x11"))
    assert_equal("\x4e\x12", NGram.normalize("\x4e\x12"))
    assert_equal("\x4e\x13", NGram.normalize("\x4e\x13"))
    assert_equal("\x4e\x14", NGram.normalize("\x4e\x14"))
    assert_equal("\x4e\x15", NGram.normalize("\x4e\x15"))
    assert_equal("\x4e\x1e", NGram.normalize("\x4e\x1e"))
    assert_equal("\x4e\x1f", NGram.normalize("\x4e\x1f"))
    assert_equal("\x4e\x20", NGram.normalize("\x4e\x20"))
    assert_equal("\x4e\x21", NGram.normalize("\x4e\x21"))
    assert_equal("\x4e\x22", NGram.normalize("\x4e\x22"))
    assert_equal("\x4e\x23", NGram.normalize("\x4e\x23"))
    assert_equal("\x4e\x13", NGram.normalize("\x4e\x24"))
    assert_equal("\x4e\x13", NGram.normalize("\x4e\x25"))
    assert_equal("\x4e\x30", NGram.normalize("\x4e\x30"))
  end

  def test_ngram
    ngram = NGram.new
    (0..4).each do |n|
      assert_nil(ngram.get(n))
    end
    ngram.add_char("\x00 ")
    (1..3).each do |n|
      assert_nil(ngram.get(n))
    end
    ngram.add_char("\x00A")
    assert_equal("\x00A", ngram.get(1))
    assert_equal("\x00 \x00A", ngram.get(2))
    assert_nil(ngram.get(3))
    ngram.add_char("\x06\xcc")
    assert_equal("\x06\x4a", ngram.get(1))
    assert_equal("\x00A\x06\x4a", ngram.get(2))
    assert_equal("\x00 \x00A\x06\x4a", ngram.get(3))
    ngram.add_char("\x1e\xa0")
    assert_equal("\x1e\xc3", ngram.get(1))
    assert_equal("\x06\x4a\x1e\xc3", ngram.get(2))
    assert_equal("\x00A\x06\x4a\x1e\xc3", ngram.get(3))
    ngram.add_char("\x30\x44")
    assert_equal("\x30\x42", ngram.get(1))
    assert_equal("\x1e\xc3\x30\x42", ngram.get(2))
    assert_equal("\x06\x4a\x1e\xc3\x30\x42", ngram.get(3))

    ngram.add_char("\x30\xa4")
    assert_equal("\x30\xa2", ngram.get(1))
    assert_equal("\x30\x42\x30\xa2", ngram.get(2))
    assert_equal("\x1e\xc3\x30\x42\x30\xa2", ngram.get(3))
    ngram.add_char("\x31\x06")
    assert_equal("\x31\x05", ngram.get(1))
    assert_equal("\x30\xa2\x31\x05", ngram.get(2))
    assert_equal("\x30\x42\x30\xa2\x31\x05", ngram.get(3))
    ngram.add_char("\xac\x01")
    assert_equal("\xac\x00", ngram.get(1))
    assert_equal("\x31\x05\xac\x00", ngram.get(2))
    assert_equal("\x30\xa2\x31\x05\xac\x00", ngram.get(3))
    ngram.add_char("\x20\x10")
    assert_nil(ngram.get(1))
    assert_equal("\xac\x00\x00 ", ngram.get(2))
    assert_equal("\x31\x05\xac\x00\x00 ", ngram.get(3))
    ngram.add_char("\x00a")
    assert_equal("\x00a", ngram.get(1))
    assert_equal("\x00 \x00a", ngram.get(2))
    assert_nil(ngram.get(3))
  end
end
