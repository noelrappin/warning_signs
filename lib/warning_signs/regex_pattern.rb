module WarningSigns
  class RegexPattern
    attr_accessor :pattern

    def initialize(raw_pattern)
      @pattern = Regexp.new(raw_pattern[1...-1])
    end

    def match?(message)
      pattern.match?(message)
    end
  end
end
