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

    def self.of(character)
      return BASIC_LATIN if ("\x00\x00".."\x00\x7f").include?(character)
      return LATIN_1_SUPPLEMENT if ("\x00\x80".."\x00\xff").include?(character)
      return GENERAL_PUNCTUATION if ("\x20\x00".."\x20\x6f").include?(character)
      return ARABIC if ("\x06\x00".."\x06\xff").include?(character)
      return LATIN_EXTENDED_ADDITIONAL if ("\x1e\x00".."\x1e\xff").include?(character)
      return HIRAGANA if ("\x30\x40".."\x30\x9f").include?(character)
      return KATAKANA if ("\x30\xa0".."\x30\xff").include?(character)
      return BOPOMOFO if ("\x31\x00".."\x31\x2f").include?(character)
      return BOPOMOFO_EXTENDED if ("\x31\a0".."\x31\xbf").include?(character)
      return CJK_UNIFIED_IDEOGRAPHS if ("\x4e\x00".."\x9f\xff").include?(character)
      return HANGUL_SYLLABES if ("\xac\x00".."\xd7\xaf").include?(character)
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
