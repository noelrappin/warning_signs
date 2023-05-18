# standard:disable Style/StderrPuts
module WarningSigns
  module Behavior
    class Stderr < Base
      def emit
        formatted_message.each { $stderr.puts(_1) }
      end
    end
  end
end
# standard:enable Style/StderrPuts
