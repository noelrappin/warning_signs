# standard:disable Style/StdoutPuts
module WarningSigns
  module Behavior
    class Stdout < Base
      def emit
        $stdout.puts(message)
        $stdout.puts(filtered_backtrace_lines)
      end
    end
  end
end
# standard:enable Style/StdoutPuts
