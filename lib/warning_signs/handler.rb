module WarningSigns
  class Handler
    attr_accessor :environments, :only_except, :source,
      :category_matcher, :backtrace_lines, :message_formatters

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
      environments: [],
      ruby_warnings: {},
      message_formatter: nil,
      message_formatters: []
    )
      @only_except = OnlyExcept.new(
        only: only.map { Pattern.for(_1) },
        except: except.map { Pattern.for(_1) }
      )
      @environments = environments.map { Environment.new(**_1.symbolize_keys) }
      if environment.present?
        @environments << Environment.new(
          environment: environment,
          behaviors: behaviors,
          behavior: behavior
        )
      end
      @source = source.to_s.downcase.inquiry
      @category_matcher = RubyCategoryMatcher.new(**ruby_warnings.symbolize_keys)
      @message_formatters = MessageFormatterList.new(
        message_formatters: message_formatters,
        message_formatter: message_formatter
      )
      raise InvalidHandlerError unless valid?
    end

    def message_formatter_for(behavior)
      message_formatters.behavior_match(behavior) ||
        MessageFormatter::Text.new
    end

    def valid?
      only_except.valid?
    end

    def known_source?(deprecation_source)
      deprecation_source.in?(%w[ruby rails])
    end

    def pattern_match?(message)
      only_except.only_except_match?(message)
    end

    def match?(deprecation)
      source_match?(deprecation.source) &&
        pattern_match?(deprecation.message) &&
        category_match?(deprecation.category)
    end

    def category_match?(category)
      category_matcher.match?(category)
    end

    def source_match?(deprecation_source)
      return known_source?(deprecation_source) if source.any?
      source == deprecation_source
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
