module Langusta
  class TagExtractor
    attr_accessor :tag
    attr_reader :count, :buffer, :target, :threshold

    def initialize(tag, threshold)
      @target = tag
      @threshold = threshold
      @count = 0
      @buffer = UCS2String.new("")
      @tag = nil
    end

    def add(line)
      if @target == @tag && line
        @buffer << line
      end
    end

    def clear
      @tag = nil
      @buffer = UCS2String.new("")
    end

    def close_tag(profile)
      if profile && @tag == @target && @buffer.length > @threshold
        gram = NGram.new
        @buffer.each_char do |char|
          gram.add_char(char)
          NGram::N_GRAM.times do |n|
            profile.add(gram.get(n))
          end
        end
        count += 1
      end
      clear()
    end
  end
end
