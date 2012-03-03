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
      # /ui stands for UTF-8 case-insensitive regexp.
      ROMAN_REGEX = /^[a-z]$/ui
      INCL_ROMAN_REGEX = /.*[a-z].*/ui
      URL_REGEX = Regexp.new("https?://[-_.?&~;+=/#a-z0-9]+")
      MAIL_REGEX = /[-_.a-z0-9]+@[-_a-z0-9]+[-_.a-z0-9]+/ui
      SPACE_REGEX = / +/
    end
  end
end
