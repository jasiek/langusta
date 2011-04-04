module Langusta
  # The class NGram generates n-sized substrings (n-grams) of an input string. Input strings are
  # constructed on a character by character basis.
  class NGram
    N_GRAM = 3
    UCS2_SPACE = "\x00\x20"

    def self.calculate_latin1_excluded
      internal_hash = JavaPropertyReader.new("messages.properties").underlying_hash
      _, value = internal_hash.find do |k, v|
        k == "NGram.LATIN1_EXCLUDE"
      end
      
      (0..(value.length - 2)).step(2).map do |index|
        value[index, 2]
      end
    end

    LATIN1_EXCLUDED = self.calculate_latin1_excluded()
    
    def self.cjk_map
      @@cjk_map ||= calculate_cjk_map()
    end

    def self.calculate_cjk_map
      internal_hash = JavaPropertyReader.new("messages.properties").underlying_hash
      m = {}
      internal_hash.select do |key, _|
        /KANJI_[0-9]{1}/ =~ key
      end.each do |_, chars|
        key = chars[0..1]
        m[key] = key
        (2..(chars.length - 2)).step(2) do |n|
          m[chars[n, 2]] = key
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
        (ch < "\x00A" || (ch < "\x00a" && ch > "\x00Z") || ch > "\x00z") ? UCS2_SPACE : ch
      when UnicodeBlock::LATIN_1_SUPPLEMENT
        LATIN1_EXCLUDED.include?(ch) ? UCS2_SPACE : ch
      when UnicodeBlock::GENERAL_PUNCTUATION
        UCS2_SPACE
      when UnicodeBlock::ARABIC
        (ch == "\x06\xcc") ? "\x06\x4a" : ch
      when UnicodeBlock::LATIN_EXTENDED_ADDITIONAL
        (ch >= "\x1e\xa0") ? "\x1e\xc3" : ch
      when UnicodeBlock::HIRAGANA
        "\x30\x42"
      when UnicodeBlock::KATAKANA
        "\x30\xa2"
      when UnicodeBlock::BOPOMOFO
        "\x31\x05"
      when UnicodeBlock::BOPOMOFO_EXTENDED
        "\x31\x05"
      when UnicodeBlock::CJK_UNIFIED_IDEOGRAPHS
        cjk_map.has_key?(ch) ? cjk_map[ch] : ch
      when UnicodeBlock::HANGUL_SYLLABES
        "\xac\x00"
      else
        ch
      end
    end

    def initialize
      @grams = [UCS2_SPACE]
      @capitalword = false
    end

    def get(n)
      return nil if @capitalword
      len = @grams.length
      return nil if n < 1 || n > 3 || len < n
      if n == 1
        ch = @grams[len - 1]
        return (ch == UCS2_SPACE) ? nil : ch
      else
        return @grams[len - n, len].join('')
      end
    end

    def add_char(character)
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
