# standard:disable Style/StdoutPuts
module WarningSigns
  module Behavior
    class Stdout < Base
      def emit
        formatted_message.each { $stdout.puts(_1) }
      end
    end
  end
end
# standard:enable Style/StdoutPuts
