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

      def formatted_message
        result = message_formatter.format_message(message, backtrace)
        result = [result] unless result.is_a?(Array)
        result
      end

      def emit
        raise NotImplementedError
      end
    end
  end
end
