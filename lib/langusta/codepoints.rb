module Langusta
  module Codepoints
    def self.gsub!(codepoint_array, regex, replacement)
      string = Langusta.cp2utf8(codepoint_array)
      string.gsub!(regex, replacement)
      codepoints = Langusta.utf82cp(string)
      codepoint_array.replace(codepoints)
    end
  end
end
