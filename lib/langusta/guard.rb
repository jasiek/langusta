module Langusta
  module Guard
    
    def self.klass(argument, klass, _method)
      return unless $debug
      raise TypeError.new("#{_method}: expected #{klass} got: #{argument.class}") unless argument.is_a?(klass)
    end
      
    def self.codepoint(codepoint, _method)
      return unless $debug
      raise ArgumentError.new([_method, ':', codepoint.to_s(16)].join) unless (0x0000..0xffff).include?(codepoint)
    end
    
    def self.codepoint_array(array, _method)
      return unless $debug
      raise TypeError.new("#{_method}: expected Array, got: #{array.class}") unless array.is_a?(Array)
      cp = array.find do |cp|
        ! (0x0000..0xffff).include?(cp)
      end && (raise ArgumentError.new("#{_method}: bad codepoint: #{cp}"))
    end
  end
end
