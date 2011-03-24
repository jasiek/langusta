module Langusta
  class NGram
    N_GRAM = 3

    # TODO
    def self.cjk_map
      @@cjk_map ||= calculate_cjk_map()
    end

    def self.calculate_cjk_map
      internal_hash = JavaPropertyReader.new("messages.properties").underlying_hash
      m = {}
      internal_hash.values.each do |chars|
        key = chars[0..1]
        m[key] = key
        (2..(chars.length - 2)).step(2) do |n|
          m[chars[n, 2]] = key
        end
      end
      m
    end

    def self.normalize(ch)
      block = UnicodeBlock.of(ch)
      case block
      when UnicodeBlock::BASIC_LATIN
        (ch < 'A' || (ch < 'a' && ch > 'Z') || ch > 'z') ? ' ' : ch
      when UnicodeBlock::LATIN_1_SUPPLEMENT
        LATIN1_EXCLUDED.include?(ch) ? ' ' : ch
      when UnicodeBlock::GENERAL_PUNCTUATION
        ' '
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
        "\xac00"
      else
        ch
      end
    end

    def initialize
      @grams = [' ']
      @capitalword = false
    end

    def get(n)
      return nil if @capitalword
      len = @grams.length
      return nil if n < 1 || n > 3 || len < n
      if n == 1
        ch = @grams[len - 1]
        return (ch == ' ') ? nil : ch
      else
        return @grams[len - n, len].join('')
      end
    end

    def add_char(character)
      raise character.inspect unless character.scan(/./mu).length == 1
      character = self.class.normalize(character)
      lastchar = @grams[-1]
      if lastchar == ' '
        @grams = [' ']
        @capitalword = false
        return if character == ' '
      elsif @grams.length > N_GRAM
        @grams = @grams[1..-1]
      end
      @grams << character

      if character.upcase == character
        if lastchar.upcase == lastchar
          @capitalword = true
        end
      else
        @capitalword = false
      end
    end
  end
end
