module WarningSigns
  module Behavior
    class Log < Base
      def emit
        Rails.logger.warn(message)
        filtered_backtrace_lines.split("\n").each { Rails.logger.warn(_1) }
      end
    end
  end
end
