module Langusta
  module UnicodeBlock
    # Half-baked implementation of Java's UnicodeBlock.

    OTHER                           = 0
    BASIC_LATIN                     = 1
    LATIN_1_SUPPLEMENT              = 2
    GENERAL_PUNCTUATION             = 3
    ARABIC                          = 4
    LATIN_EXTENDED_ADDITIONAL       = 5
    HIRAGANA                        = 6
    KATAKANA                        = 7
    BOPOMOFO                        = 8
    BOPOMOFO_EXTENDED               = 9
    CJK_UNIFIED_IDEOGRAPHS          = 10
    HANGUL_SYLLABES                 = 11

    BASIC_LATIN_RANGE               = 0x0000..0x007f
    LATIN_1_SUPPLEMENT_RANGE        = 0x0080..0x00ff
    GENERAL_PUNCTUATION_RANGE       = 0x2000..0x206f
    ARABIC_RANGE                    = 0x0600..0x06ff
    LATIN_EXTENDED_ADDITIONAL_RANGE = 0x1e00..0x1eff
    HIRAGANA_RANGE                  = 0x3040..0x309f
    KATAKANA_RANGE                  = 0x30a0..0x30ff
    BOPOMOFO_RANGE                  = 0x3100..0x31bf
    BOPOMOFO_EXTENDED_RANGE         = 0x31a0..0x31bf
    CJK_UNIFIED_IDEOGRAPHS_RANGE    = 0x4e00..0x9fff
    HANGUL_SYLLABES_RANGE           = 0xac00..0xd7af

    def self.of(character)
      case character
      when BASIC_LATIN_RANGE               then return BASIC_LATIN
      when LATIN_1_SUPPLEMENT_RANGE        then return LATIN_1_SUPPLEMENT
      when GENERAL_PUNCTUATION_RANGE       then return GENERAL_PUNCTUATION
      when ARABIC_RANGE                    then return ARABIC
      when LATIN_EXTENDED_ADDITIONAL_RANGE then return LATIN_EXTENDED_ADDITIONAL
      when HIRAGANA_RANGE                  then return HIRAGANA
      when KATAKANA_RANGE                  then return KATAKANA
      when BOPOMOFO_RANGE                  then return BOPOMOFO
      when BOPOMOFO_EXTENDED_RANGE         then return BOPOMOFO_EXTENDED
      when CJK_UNIFIED_IDEOGRAPHS_RANGE    then return CJK_UNIFIED_IDEOGRAPHS
      when HANGUL_SYLLABES_RANGE           then return HANGUL_SYLLABES
      else
        return OTHER
      end
    end

    def self.is_upper_case?(character)
      (@@upper_case_table ||= compute_upper_case_table()).include?(character)
    end

    def self.compute_upper_case_table
      File.open(UPPERCASE_BIN).read.unpack('n*')
    end
  end
end
