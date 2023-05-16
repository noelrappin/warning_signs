module WarningSigns
  module Behavior
    class Raise < Base
      def emit
        raise UnhandledDeprecationError, message
      end
    end
  end
end
