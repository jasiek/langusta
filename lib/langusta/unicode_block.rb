module Langusta
  module UnicodeBlock
    # Half-baked implementation of Java's UnicodeBlock.

    OTHER = 0
    BASIC_LATIN = 1
    LATIN_1_SUPPLEMENT = 2
    GENERAL_PUNCTUATION = 3
    ARABIC = 4
    LATIN_EXTENDED_ADDITIONAL = 5
    HIRAGANA = 6
    KATAKANA = 7
    BOPOMOFO = 8
    BOPOMOFO_EXTENDED = 9
    CJK_UNIFIED_IDEOGRAPHS = 10
    HANGUL_SYLLABES = 11

    BASIC_LATIN_RANGE = "\x00\x00".."\x00\x7f"
    LATIN_1_SUPPLEMENT_RANGE = "\x00\x80".."\x00\xff"
    GENERAL_PUNCTUATION_RANGE = "\x20\x00".."\x20\x6f"
    ARABIC_RANGE = "\x06\x00".."\x06\xff"
    LATIN_EXTENDED_ADDITIONAL_RANGE = "\x1e\x00".."\x1e\xff"
    HIRAGANA_RANGE = "\x30\x40".."\x30\x9f"
    KATAKANA_RANGE = "\x30\xa0".."\x30\xff"
    BOPOMOFO_RANGE = "\x31\x00".."\x31\xbf"
    BOPOMOFO_EXTENDED_RANGE = "\x31\xa0".."\x31\xbf"
    CJK_UNIFIED_IDEOGRAPHS_RANGE = "\x4e\x00".."\x9f\xff"
    HANGUL_SYLLABES_RANGE = "\xac\x00".."\xd7\xaf"

    def self.of(character)
      return BASIC_LATIN if BASIC_LATIN_RANGE.include?(character)
      return LATIN_1_SUPPLEMENT if LATIN_1_SUPPLEMENT_RANGE.include?(character)
      return GENERAL_PUNCTUATION if GENERAL_PUNCTUATION_RANGE.include?(character)
      return ARABIC if ARABIC_RANGE.include?(character)
      return LATIN_EXTENDED_ADDITIONAL if LATIN_EXTENDED_ADDITIONAL_RANGE.include?(character)
      return HIRAGANA if HIRAGANA_RANGE.include?(character)
      return KATAKANA if KATAKANA_RANGE.include?(character)
      return BOPOMOFO if BOPOMOFO_RANGE.include?(character)
      return BOPOMOFO_EXTENDED if BOPOMOFO_EXTENDED_RANGE.include?(character)
      return CJK_UNIFIED_IDEOGRAPHS if CJK_UNIFIED_IDEOGRAPHS_RANGE.include?(character)
      return HANGUL_SYLLABES if HANGUL_SYLLABES_RANGE.include?(character)
      return OTHER
    end

    def self.is_upper_case?(character)
      (@@upper_case_table ||= compute_upper_case_table()).include?(character)
    end

    def self.compute_upper_case_table
      File.open(UPPERCASE_BIN).read
    end
  end
end
