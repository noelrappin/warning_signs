module WarningSigns
  module Behavior
    class Ignore < Base
      def emit
        # no-op
      end
    end
  end
end
