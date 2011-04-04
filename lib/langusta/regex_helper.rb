module Langusta
  module RegexHelper
    def self._u16(string)
      string.unpack("U*").pack("n*")
    end

    ROMAN_REGEX = Oniguruma::ORegexp.new(_u16("^[A-Za-z]$"), "", "UTF16_BE", "java")
    INCL_ROMAN_REGEX = Oniguruma::ORegexp.new(_u16(".*[A-Za-z].*"), "", "UTF16_BE", "java")
  end
end
