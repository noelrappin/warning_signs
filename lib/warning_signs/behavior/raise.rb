module WarningSigns
  module Behavior
    class Raise < Base
      def filtered_backtrace
        return backtrace if message_formatter.backtrace_lines.zero?
        message_formatter.filtered_backtrace(backtrace)
      end

      def emit
        raise UnhandledDeprecationError,
          formatted_message.first,
          filtered_backtrace[1..].map(&:to_s)
      end
    end
  end
end
