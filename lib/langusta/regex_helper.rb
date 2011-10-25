module Langusta
  module RegexHelper
    if RUBY_VERSION < "1.9"
      include Oniguruma

      def self._u16(string)
        string.unpack("U*").pack("n*")
      end
      
      ROMAN_REGEX = ORegexp.new(_u16("^[A-Za-z]$"), "", "UTF16_BE", "java")
      INCL_ROMAN_REGEX = ORegexp.new(_u16(".*[A-Za-z].*"), "", "UTF16_BE", "java")
      URL_REGEX = ORegexp.new(_u16("https?://[-_.?&~;+=/#0-9A-Za-z]+"), "", "UTF16_BE", "java")
      MAIL_REGEX = ORegexp.new(_u16("[-_.0-9A-Za-z]+@[-_0-9A-Za-z]+[-_.0-9A-Za-z]+"), "", "UTF_16BE", "java")
      SPACE_REGEX = ORegexp.new(_u16(" +"), "", "UTF16_BE", "java")
    else
      def self._u16(string)
        string.force_encoding("ucs-2be")
      end

      ROMAN_REGEX = Regexp.new(_u16("^[A-Za-z]$"))
      INCL_ROMAN_REGEX = Regexp.new(_u16(".*[A-Za-z].*"))
      URL_REGEX = Regexp.new(_u16("https?://[-_.?&~;+=/#0-9A-Za-z]+"))
      MAIL_REGEX = Regexp.new(_u16("[-_.0-9A-Za-z]+@[-_0-9A-Za-z]+[-_.0-9A-Za-z]+"))
      SPACE_REGEX = Regexp.new(_u16(" +"))
    end
  end
end
