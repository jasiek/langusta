module Langusta
  class UCS2String
    include Enumerable
    UTF8_TO_UCS2BE_ICONV = Iconv.new('ucs-2be', 'utf-8')
    UCS2BE_TO_UCS2BE_ICONV = Iconv.new('ucs-2be', 'ucs-2be')

    attr_reader :underlying

    def self.from_utf8(utf8_string)
      self.new(Converter.to_ucs2_string(utf8_string))
    end

    def initialize(underlying)
      @underlying = underlying
    end

    def [](index)
      @underlying[index / 2, 2]
    end

    def gsub!(oregexp, subst)
      oregexp.gsub!(@underlying, subst)
      self
    end

    def map(&blk)
      mapped = []
      each_char do |char|
        mapped << blk.call(char)
      end
      return UCS2String.new(mapped.join)
    end
    
    def hash
      @underlying.hash
    end

    def <<(ucs2string)
      case ucs2string
      when UCS2String
        @underlying += ucs2string.underlying
      when String
        @underlying += ucs2string
      else
        raise TypeError
      end
      self
    end

    def each_char(&blk)
      (0..(@underlying.length - 2)).step(2) do |index|
        blk.call(@underlying[index, 2])
      end
    end
    alias :each :each_char

    def eql?(other)
      other.is_a?(UCS2String) && self.underlying.eql?(other.underlying)
    end
    
    def ==(other)
      self.underlying == other.underlying
    end

    def size
      @underlying.size / 2
    end
    alias :length :size

    # String encoding converters for different versions of the interpreter.

    module Ruby18Converter
      def self.to_ucs2_string(ruby_utf8_string)
        Iconv.conv('ucs-2be', 'utf-8', ruby_utf8_string)
      end
    end

    module Ruby19Converter
      def self.to_ucs2_string(ruby_utf8_string)
        ruby_utf8_string.encode('utf-16be')
      end
    end

    Converter = (RUBY_VERSION < "1.9") ? Ruby18Converter : Ruby19Converter
  end
end
