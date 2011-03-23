class Langusta::NGram
  N_GRAM = 3

  def self.normalize(character)
    return character if /^[A-Za-z\x80\xa1]$/mu =~ character
    ' '
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

    @capitalword = (character.upcase == character)
  end
end
