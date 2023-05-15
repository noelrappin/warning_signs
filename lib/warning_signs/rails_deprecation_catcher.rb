module WarningSigns
  class RailsDeprecationCatcher < ActiveSupport::Subscriber
    include CallerLocationHelper
    attach_to :rails

    def deprecation(event)
      Deprecation.new(
        event.payload[:message],
        source: "rails",
        backtrace: caller_locations_filtered
      ).invoke
    end
  end
end
