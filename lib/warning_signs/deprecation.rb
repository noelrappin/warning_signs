module WarningSigns
  class Deprecation
    attr_accessor :message, :source, :category

    def initialize(message, source:, category: nil)
      @message = message
      @source = source.to_s.downcase.inquiry
      @category = category
    end

    def handler
      World.instance.handler_for(self)
    end

    # force raise to be the last element if it is present
    def behaviors
      result = (handler&.environment&.behaviors || []).inquiry
      return result if !result.raise?
      (result - ["raise"]) << "raise"
    end

    def invoke
      behaviors.each do |behavior|
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
end
