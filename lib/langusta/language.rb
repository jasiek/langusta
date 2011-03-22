class Langusta::Language
  attr_reader :lang, :prob

  def initialize(lang, prob)
    @lang = lang
    @prob = prob
  end

  def to_s
    lang ? "#{lang}:#{prob}" : ""
  end
end
