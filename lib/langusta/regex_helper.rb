module Langusta
  module RegexHelper
    include Oniguruma

    def self._u16(string)
      string.unpack("U*").pack("n*")
    end

    ROMAN_REGEX = ORegexp.new(_u16("^[A-Za-z]$"), "", "UTF16_BE", "java")
    INCL_ROMAN_REGEX = ORegexp.new(_u16(".*[A-Za-z].*"), "", "UTF16_BE", "java")
    URL_REGEX = ORegexp.new(_u16("https?://[-_.?&~;+=/#0-9A-Za-z]+"), "", "UTF16_BE", "java")
    MAIL_REGEX = ORegexp.new(_u16("[-_.0-9A-Za-z]+@[-_0-9A-Za-z]+[-_.0-9A-Za-z]+"), "", "UTF_16BE", "java")
    SPACE_REGEX = ORegexp.new(_u16("(\x00\x20)*"), "", "UTF16_BE", "java")
  end
end
