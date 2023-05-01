module WarningSigns
  class RailsDeprecationCatcher < ActiveSupport::Subscriber
    attach_to :rails

    def deprecation(event)
      Deprecation.new(event.payload[:message], source: "rails").invoke
    end
  end
end
