module Langusta
  class UCS2String
    include Enumerable

    attr_reader :underlying

    def initialize(underlying)
      @underlying = Iconv.conv("ucs-2", "ucs-2", underlying)
    end

    def [](index)
      @underlying[index / 2, 2]
    end

    def gsub!(oregexp, subst)
      oregexp.gsub!(@underlying, subst)
    end

    def <<(ucs2string)
      raise TypeError unless ucs2string.is_a?(UCS2String)
      self.new(@underlying + ucs2string.underlying)
    end

    def each_char(&blk)
      (0..(@underlying.length - 2)).step(2) do |index|
        blk.call(@underlying[index, 2])
      end
    end
    alias :each :each_char
  end
end
