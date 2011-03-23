# -*- coding: utf-8 -*-
require 'test/helper'

class NGramTest < Test::Unit::TestCase
  def test_constants
    assert_equal(3, NGram::N_GRAM)
  end

  def test_normalize_with_latin
    assert_equal(" ", NGram.normalize("\x00")) # \0
    assert_equal(" ", NGram.normalize("\x09")) # <control>
    assert_equal(" ", NGram.normalize("\x20")) # space
    assert_equal(" ", NGram.normalize("\x30")) # 0
    assert_equal(" ", NGram.normalize("\x40")) # @
    assert_equal("\x41", NGram.normalize("\x41")) # A
    assert_equal("\x5a", NGram.normalize("\x5a")) # Z
    assert_equal(" ", NGram.normalize("\x5b")) # [
    assert_equal(" ", NGram.normalize("\x60")) # `
    assert_equal("\x61", NGram.normalize("\x61")) # a
    assert_equal("\x7a", NGram.normalize("\x7a")) # z
    assert_equal(" ", NGram.normalize("\x7b")) # {
    assert_equal(" ", NGram.normalize("\x7f")) # <control>
    assert_equal("\x80", NGram.normalize("\x80")) # <control>
    assert_equal(" ", NGram.normalize("\xa0")) # <control>
    assert_equal("\xa1", NGram.normalize("\xa1")) # <control>
  end

  def test_ngram
    ngram = NGram.new
    (0..4).each do |n|
      assert_nil(ngram.get(n))
    end
    ngram.add_char(' ')
    (1..3).each do |n|
      assert_nil(ngram.get(n))
    end
    ngram.add_char('a')
    assert_equal('a', ngram.get(1))
    assert_equal(' a', ngram.get(2))
    assert_nil(ngram.get(3))
    ngram.add_char('ć')
    assert_equal('ć', ngram.get(1))
    assert_equal('ać', ngram.get(2))
    assert_equal(' ać', ngram.get(3))
    ngram.add_char('1')
    assert_nil(ngram.get(1))
    assert_equal('ć ', ngram.get(2))
    assert_equal('ać ', ngram.get(3))
    ngram.add_char('a')
    assert_equal('a', ngram.get(1))
    assert_equal(' a', ngram.get(2))
    assert_nil(ngram.get(3))
  end
end
