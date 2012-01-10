# -*- coding: utf-8 -*-
require 'test/helper'

class NGramTest < Test::Unit::TestCase
  def test_constants
    assert_equal(3, NGram::N_GRAM)
  end

  def test_normalize_with_latin
    assert_equal(0x20, NGram.normalize(0x00)) # \0
    assert_equal(0x20, NGram.normalize(0x09)) # <control>
    assert_equal(0x20, NGram.normalize(0x20)) # space
    assert_equal(0x20, NGram.normalize(0x30)) # 0
    assert_equal(0x20, NGram.normalize(0x40)) # @
    assert_equal(0x41, NGram.normalize(0x41)) # A
    assert_equal(0x5a, NGram.normalize(0x5a)) # Z
    assert_equal(0x20, NGram.normalize(0x5b)) # [
    assert_equal(0x20, NGram.normalize(0x60)) # `
    assert_equal(0x61, NGram.normalize(0x61)) # a
    assert_equal(0x7a, NGram.normalize(0x7a)) # z
    assert_equal(0x20, NGram.normalize(0x7b)) # {
    assert_equal(0x20, NGram.normalize(0x7f)) # <control>
    assert_equal(0x80, NGram.normalize(0x80)) # <control>
    assert_equal(0x20, NGram.normalize(0xa0)) # <control>
    assert_equal(0xa1, NGram.normalize(0xa1)) # <control>
  end

  def test_normalize_with_cjk_kanji
    assert_equal(0x4e00, NGram.normalize(0x4e00))
    assert_equal(0x4e01, NGram.normalize(0x4e01))
    assert_equal(0x4e02, NGram.normalize(0x4e02))
    assert_equal(0x4e01, NGram.normalize(0x4e03))
    assert_equal(0x4e04, NGram.normalize(0x4e04))
    assert_equal(0x4e05, NGram.normalize(0x4e05))
    assert_equal(0x4e06, NGram.normalize(0x4e06))
    assert_equal(0x4e07, NGram.normalize(0x4e07))
    assert_equal(0x4e08, NGram.normalize(0x4e08))
    assert_equal(0x4e09, NGram.normalize(0x4e09))
    assert_equal(0x4e10, NGram.normalize(0x4e10))
    assert_equal(0x4e11, NGram.normalize(0x4e11))
    assert_equal(0x4e12, NGram.normalize(0x4e12))
    assert_equal(0x4e13, NGram.normalize(0x4e13))
    assert_equal(0x4e14, NGram.normalize(0x4e14))
    assert_equal(0x4e15, NGram.normalize(0x4e15))
    assert_equal(0x4e1e, NGram.normalize(0x4e1e))
    assert_equal(0x4e1f, NGram.normalize(0x4e1f))
    assert_equal(0x4e20, NGram.normalize(0x4e20))
    assert_equal(0x4e21, NGram.normalize(0x4e21))
    assert_equal(0x4e22, NGram.normalize(0x4e22))
    assert_equal(0x4e23, NGram.normalize(0x4e23))
    assert_equal(0x4e13, NGram.normalize(0x4e24))
    assert_equal(0x4e13, NGram.normalize(0x4e25))
    assert_equal(0x4e30, NGram.normalize(0x4e30))
  end

  def test_ngram
    ngram = NGram.new
    (0..4).each do |n|
      assert_nil(ngram.get(n))
    end
    ngram.add_char(0x20)
    (1..3).each do |n|
      assert_nil(ngram.get(n))
    end

    ngram.add_char(0x0041)
    assert_equal([0x0041], ngram.get(1))
    assert_equal([0x0020, 0x0041], ngram.get(2))
    assert_nil(ngram.get(3))

    ngram.add_char(0x06cc)
    assert_equal([0x064a], ngram.get(1))
    assert_equal([0x0041, 0x64a], ngram.get(2))
    assert_equal([0x0020, 0x0041, 0x064a], ngram.get(3))

    ngram.add_char(0x1ea0)
    assert_equal([0x1ec3], ngram.get(1))
    assert_equal([0x064a, 0x1ec3], ngram.get(2))
    assert_equal([0x0041, 0x064a, 0x1ec3], ngram.get(3))

    ngram.add_char(0x3044)
    assert_equal([0x3042], ngram.get(1))
    assert_equal([0x1ec3, 0x3042], ngram.get(2))
    assert_equal([0x064a, 0x1ec3, 0x3042], ngram.get(3))

    ngram.add_char(0x30a4)
    assert_equal([0x30a2], ngram.get(1))
    assert_equal([0x3042, 0x30a2], ngram.get(2))
    assert_equal([0x1ec3, 0x3042, 0x30a2], ngram.get(3))

    ngram.add_char(0x3106)
    assert_equal([0x3105], ngram.get(1))
    assert_equal([0x30a2, 0x3105], ngram.get(2))
    assert_equal([0x3042, 0x30a2, 0x3105], ngram.get(3))

    ngram.add_char(0xac01)
    assert_equal([0xac00], ngram.get(1))
    assert_equal([0x3105, 0xac00], ngram.get(2))
    assert_equal([0x30a2, 0x3105, 0xac00], ngram.get(3))

    ngram.add_char(0x2010)
    assert_nil(ngram.get(1))
    assert_equal([0xac00, 0x0020], ngram.get(2))
    assert_equal([0x3105, 0xac00, 0x0020], ngram.get(3))

    ngram.add_char(0x0041)
    assert_equal([0x0041], ngram.get(1))
    assert_equal([0x0020, 0x0041], ngram.get(2))
    assert_nil(ngram.get(3))
  end

  def array_of_codepoints
    array_of_codepoints.pack('n*')
  end
end
