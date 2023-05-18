module WarningSigns
  class MessageFormatterList
    include Enumerable

    attr_reader :message_formatters

    def initialize(message_formatters: [], message_formatter: nil)
      @message_formatters = message_formatters.map do
        MessageFormatter::Base.for(**_1)
      end
      @message_formatters << MessageFormatter::Base.for(**message_formatter) if message_formatter
    end

    def each(&block)
      message_formatters.each(&block)
    end

    def behavior_match(behavior)
      message_formatters.find do
        _1.behaviors.only_except_match?(behavior) &&
          _1.environments.only_except_match?(Rails.env)
      end
    end
  end
end
