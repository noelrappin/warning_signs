module WarningSigns
  class Deprecation
    attr_accessor :message, :source, :category, :backtrace

    def initialize(message, source:, category: nil, backtrace: [])
      @message = message
      @source = source.to_s.downcase.inquiry
      @category = category
      @backtrace = backtrace || []
    end

    def handler
      World.instance.handler_for(self)
    end

    def message_formatter_for(behavior)
      handler.message_formatter_for(behavior)
    end

    # force raise to be the last element if it is present
    def behaviors
      result = (handler&.environment&.behaviors || []).inquiry
      return result unless result.raise?
      (result - ["raise"]) << "raise"
    end

    def invoke
      behaviors.each do |behavior_type|
        Behavior::Base.for(
          behavior_type,
          message,
          backtrace,
          message_formatter_for(behavior_type)
        ).emit
      end
    end
  end
end
