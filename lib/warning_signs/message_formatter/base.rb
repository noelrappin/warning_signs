module WarningSigns
  module MessageFormatter
    class Base
      include CallerLocationHelper
      attr_reader :backtrace_lines

      def self.for(**args)
        type = args.delete(:format) || "text"
        class_name = "WarningSigns::MessageFormatter::#{type.classify}"
        class_name.constantize.new(**args)
      end

      def initialize(backtrace_lines: 0)
        @backtrace_lines = backtrace_lines
      end

      def format_message(message, backtrace)
        raise NotImplementedError
      end

      def filtered_backtrace(backtrace)
        return [] if backtrace.nil?
        result = backtrace.reject do |location|
          ignore_line(location.to_s)
        end
        result.empty? ? backtrace : result
      end

      def filtered_backtrace_lines(backtrace)
        return [] if backtrace_lines.zero?
        filtered_backtrace(backtrace)[1..backtrace_lines] || []
      end
    end
  end
end
