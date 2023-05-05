module WarningSigns
  class StringPattern
    attr_accessor :pattern

    def initialize(raw_pattern)
      @pattern = raw_pattern
    end

    def match?(message)
      message.include?(pattern)
    end
  end
end
