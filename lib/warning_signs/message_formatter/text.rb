module WarningSigns
  module MessageFormatter
    class Text < Base
      def format_message(message, backtrace)
        [message] + filtered_backtrace_lines(backtrace)
      end
    end
  end
end
