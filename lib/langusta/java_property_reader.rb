module Langusta
  class JavaPropertyReader
    # This is a minimal implementation, don't expect this to actually work.

    def initialize(filename)
      @lines = File.open(filename).read
      parse()
    end

    def [](property)
      @properties[property]
    end

    def underlying_hash
      @properties
    end

    private
    def parse
      @properties = {}
      @lines.each do |line|
        prop_name, value = line.split(/\=/)
        @properties[prop_name] = parse_value(value)
      end
    end

    def parse_value(value)
      codepoints = value.scan(/([0-9A-F]{4})/)
      codepoints.map do |cp|
        int_cp = cp.first.to_i(16)
        [int_cp / 256, int_cp % 256].pack("c*")
      end.join
    end
  end
end
