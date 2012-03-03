module Langusta
  module RegexHelper
    if RUBY_VERSION < "1.9"
      include Oniguruma
      
      ROMAN_REGEX = ORegexp.new("^[a-z]$", :options => OPTION_IGNORECASE)
      INCL_ROMAN_REGEX = ORegexp.new(".*[a-z].*", :options => OPTION_IGNORECASE)
      URL_REGEX = ORegexp.new("https?://[-_.?&~;+=/#0-9a-z]+", :options => OPTION_IGNORECASE)
      MAIL_REGEX = ORegexp.new("[-_.0-9a-z]+@[-_0-9a-z]+[-_.0-9a-z]+", :options => OPTION_IGNORECASE)
      SPACE_REGEX = ORegexp.new(" +")
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
