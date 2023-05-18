module WarningSigns
  module MessageFormatter
    class Hash < Base
      def format_message(message, backtrace)
        {
          message: message,
          backtrace: filtered_backtrace_lines(backtrace).map(&:to_s)
        }
      end
    end
  end
end
