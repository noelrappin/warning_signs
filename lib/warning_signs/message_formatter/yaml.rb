module WarningSigns
  module MessageFormatter
    class Yaml < Base
      def format_message(message, backtrace)
        {
          message: message,
          backtrace: filtered_backtrace_lines(backtrace).map(&:to_s)
        }.to_yaml
      end
    end
  end
end
