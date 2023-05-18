module WarningSigns
  module MessageFormatter
    class Json < Base
      def format_message(message, backtrace)
        {
          message: message,
          backtrace: filtered_backtrace_lines(backtrace).map(&:to_s)
        }.to_json
      end
    end
  end
end
