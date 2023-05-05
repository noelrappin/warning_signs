module WarningSigns
  class Pattern
    def self.for(raw_pattern)
      if raw_pattern.starts_with?("/") && raw_pattern.ends_with?("/")
        RegexPattern.new(raw_pattern)
      else
        StringPattern.new(raw_pattern)
      end
    end
  end
end
