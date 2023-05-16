module WarningSigns
  module Behavior
    class Base
      attr_reader :message_formatter, :message, :backtrace

      def self.for(behavior_type, *args)
        class_name = "WarningSigns::Behavior::#{behavior_type.classify}"
        class_name.constantize.new(*args)
      end

      def initialize(message, backtrace, message_formatter)
        @message = message
        @backtrace = backtrace
        @message_formatter = message_formatter
      end

      def filtered_backtrace_lines
        message_formatter.filtered_backtrace_lines(backtrace)
      end

      def emit
        raise NotImplementedError
      end
    end
  end
end
