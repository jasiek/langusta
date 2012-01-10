module Langusta
  class TagExtractor
    attr_accessor :tag
    attr_reader :count, :buffer, :target, :threshold

    def initialize(tag, threshold)
      @target = tag
      @threshold = threshold
      @count = 0
      @buffer = []
      @tag = nil
    end

    def add(line)
      if @target == @tag && line
        @buffer += line
      end
    end

    def clear
      @tag = nil
      @buffer = []
    end

    def close_tag(profile)
      if profile && @tag == @target && @buffer.length > @threshold
        gram = NGram.new
        @buffer.each do |codepoint|
          gram.add_char(codepoint)
          (1..NGram::N_GRAM).each do |n|
            profile.add(gram.get(n))
          end
        end
        @count += 1
      end
      clear()
    end
  end
end
