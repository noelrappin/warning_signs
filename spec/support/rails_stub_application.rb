RSpec.configure do |config|
  config.before(:example) do
    without_partial_double_verification do
      deprecators = ActiveSupport::Deprecation::Deprecators.new.tap do |deprecators|
        deprecators[:rails] = ActiveSupport::Deprecation.new
      end
      mock_app = OpenStruct.new(deprecators: deprecators)
      allow(Rails)
        .to receive(:application)
        .and_return(mock_app)
    end
    WarningSigns::World.instance.rails_set_up
  end
end

class RailsWarningEmitter
  def self.emit(message)
    if ActiveSupport.version >= Gem::Version.new("7.1.0")
      Rails.application.deprecators[:rails].warn(message)
    else
      ActiveSupport::Deprecation.warn(message)
    end
  end
end
