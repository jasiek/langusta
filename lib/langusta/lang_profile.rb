require 'set'

class Langusta::LangProfile
  MINIMUM_FREQ = 2
  LESS_FREQ_RATIO = 100_000

  attr_reader :name, :freq, :n_words

  def initialize(name=nil)
    @name = name
    @freq = {}
    @n_words = [0, 0, 0]
  end

  def add(gram)
    return if @name.nil? or gram.nil?
    length = gram.mb_chars.size
    return if length < 1 or length > NGram.N_GRAM
    @n_words[length - 1] += 1
    @freq[gram] ||= 0
    @freq[gram] += 1
  end

  def omit_less_freq
    return if @name.nil?
    threshold = @n_words[0]
    threshold = MINIMUM_FREQ if (threshold < MINIMUM_FREQ)
    keys = Set.new(@freq.keys)
    roman = 0
    keys.each do |key|
      count = @freq[key]
      if count <= threshold
        @n_words[key.mb_chars.size - 1] -= count
        @freq.delete(key)
      else
        if /^[A-Za-z]$/ =~ key
          roman += count
        end
      end
    end
    
    if roman < @n_words[0] / 3
      keys2 = Set.new(@freq.keys)
      keys2.each do |key|
        if /.*[A-Za-z].*/ =~ key
          @n_words[key.mb_chars.size - 1] -= @freq[key]
          @freq.delete(key)
        end
      end
    end
  end
end
