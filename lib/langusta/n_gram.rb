module Langusta
  # The class NGram generates n-sized substrings (n-grams) of an input string. Input strings are
  # constructed on a character by character basis.
  class NGram
    N_GRAM = 3
    UCS2_SPACE = 0x0020

    def self.calculate_latin1_excluded
      JavaPropertyReader.new(MESSAGES_PROPERTIES)["NGram.LATIN1_EXCLUDE"]
    end

    LATIN1_EXCLUDED = self.calculate_latin1_excluded()
    
    def self.cjk_map
      @@cjk_map ||= calculate_cjk_map()
    end

    def self.calculate_cjk_map
      internal_hash = JavaPropertyReader.new(MESSAGES_PROPERTIES).underlying_hash
      m = {}
      internal_hash.select do |key, _|
        /KANJI_[0-9]{1}/ =~ key
      end.each do |_, chars|
        key = chars.first
        chars.each do |cp|
          m[cp] = key
        end
      end
      m
    end

    # Normalizes certain characters - numeric, japanese characters, arabic script and so on.
    # @param ch (Codepoint in the range of 0x0000-0xFFFF).
    # @return [Integer] representing the UnicodeBlock of a given character.
    def self.normalize(ch)
      block = UnicodeBlock.of(ch)
      case block
      when UnicodeBlock::BASIC_LATIN
        (ch < 0x0041 || (ch < 0x0061 && ch > 0x005a) || ch > 0x007a) ? UCS2_SPACE : ch
      when UnicodeBlock::LATIN_1_SUPPLEMENT
        LATIN1_EXCLUDED.include?(ch) ? UCS2_SPACE : ch
      when UnicodeBlock::GENERAL_PUNCTUATION
        UCS2_SPACE
      when UnicodeBlock::ARABIC
        (ch == 0x06cc) ? 0x064a : ch
      when UnicodeBlock::LATIN_EXTENDED_ADDITIONAL
        (ch >= 0x1ea0) ? 0x1ec3 : ch
      when UnicodeBlock::HIRAGANA
        0x3042
      when UnicodeBlock::KATAKANA
        0x30a2
      when UnicodeBlock::BOPOMOFO
        0x3105
      when UnicodeBlock::BOPOMOFO_EXTENDED
        0x3105
      when UnicodeBlock::CJK_UNIFIED_IDEOGRAPHS
        cjk_map.has_key?(ch) ? cjk_map[ch] : ch
      when UnicodeBlock::HANGUL_SYLLABES
        0xac00
      else
        ch
      end
    end

    def initialize
      @grams = [UCS2_SPACE]
      @capitalword = false
    end

    # Retrieves an n-sized NGram from the current sequence.
    # @param n [Integer] length of NGram.
    # @return [Array<Integer>] n-sized NGram.
    def get(n)
      return nil if @capitalword
      len = @grams.length
      return nil if n < 1 || n > 3 || len < n
      if n == 1
        ch = @grams[len - 1]
        return (ch == UCS2_SPACE) ? nil : [ch]
      else
        return @grams[len - n, len]
      end
    end

    # Adds a single character to an NGram sequence.
    # @param character [Fixnum] Two-byte Unicode codepoint.
    def add_char(character)
      Guard.klass(character, Fixnum, __method__)
      Guard.codepoint(character, __method__)

      character = NGram.normalize(character)
      lastchar = @grams[-1]
      if lastchar == UCS2_SPACE
        @grams = [UCS2_SPACE]
        @capitalword = false
        return if character == UCS2_SPACE
      elsif @grams.length > N_GRAM
        @grams = @grams[1..-1]
      end
      @grams << character

      if UnicodeBlock.is_upper_case?(character)
        if UnicodeBlock.is_upper_case?(lastchar)
          @capitalword = true
        end
      else
        @capitalword = false
      end
    end
  end
end
