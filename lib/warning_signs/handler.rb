module WarningSigns
  class Handler
    attr_accessor :environments, :except, :only, :source

    def self.from_hash(hash)
      new(**hash.symbolize_keys)
    end

    def initialize(
      behavior: nil,
      behaviors: [],
      environment: nil,
      except: [],
      only: [],
      source: "any",
      environments: []
    )
      @except = except
      @only = only
      @environments = environments.map { Environment.new(**_1.symbolize_keys) }
      if environment.present?
        @environments << Environment.new(environment: environment, behaviors: behaviors, behavior: behavior)
      end
      @source = source.to_s.downcase.inquiry
      raise InvalidHandlerError unless valid?
    end

    def valid?
      except.empty? || only.empty?
    end

    def known_source?(deprecation_source)
      deprecation_source.in?(%w[ruby rails])
    end

    def match?(deprecation)
      source_match?(deprecation.source) &&
        pattern_match?(deprecation.message)
    end

    def pattern_match?(message)
      only_match?(message) && except_match?(message)
    end

    def source_match?(deprecation_source)
      return known_source?(deprecation_source) if source.any?
      source == deprecation_source
    end

    def only_match?(message)
      return true if only.empty?
      only.any? do |only_pattern|
        message.include?(only_pattern)
      end
    end

    def except_match?(message)
      return true if except.empty?
      except.none? do |only_pattern|
        message.include?(only_pattern)
      end
    end

    def enabled_for_ruby?
      source.ruby? || source.all?
    end

    def enabled_for_rails?
      source.rails? || source.all?
    end

    def environment(current: nil)
      current ||= Rails.env
      environments.find { _1.environment == current } ||
        environments.find { _1.environment.all? } ||
        environments.find { _1.environment.other? }
    end
  end
end
