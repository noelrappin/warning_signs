module WarningSigns
  module Behavior
    class Log < Base
      def emit
        formatted_message.each { Rails.logger.warn(_1) }
      end
    end
  end
end
