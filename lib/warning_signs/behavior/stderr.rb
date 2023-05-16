# standard:disable Style/StderrPuts
module WarningSigns
  module Behavior
    class Stderr < Base
      def emit
        $stderr.puts(message)
        $stderr.puts(filtered_backtrace_lines)
      end
    end
  end
end
# standard:enable Style/StderrPuts
