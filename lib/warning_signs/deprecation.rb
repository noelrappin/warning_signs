module WarningSigns
  class Deprecation
    attr_accessor :message, :source

    def initialize(message, source:)
      @message = message
      @source = source.to_s.downcase.inquiry
    end

    def handler
      World.instance.handler_for(self)
    end

    def behavior
      handler&.environment&.behavior
    end

    def invoke
      case behavior
      when "raise"
        raise UnhandledDeprecationError, message
      when "log"
        Rails.logger.warn(message)
      when "stderr"
        $stderr.puts(message) # standard:disable Style/StderrPuts
      end
    end
  end
end
