module Langusta
  module Codepoints
    GSUB_SELECTOR = RUBY_VERSION < "1.9" ? :gsub18 : :gsub19

    def self.gsub!(codepoint_array, regex, replacement)
      string = Langusta.cp2utf8(codepoint_array)
      string = send(GSUB_SELECTOR, string, regex, replacement)
      codepoint_array.replace(Langusta.utf82cp(string))
    end

    def self.gsub18(string, oregex, replacement)
      oregex.gsub(string, replacement)
    end

    def self.gsub19(string, regex, replacement)
      string.gsub(regex, replacement)
    end
  end
end
