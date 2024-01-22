RSpec.describe "with a simple file that logs everything" do
  let(:world) { WarningSigns::World.instance }

  before do
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
    WarningSigns::World.from_file("spec/fixtures/multiple_formatters_by_env.yml")
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world.handlers.first.environments.first.environment).to be_all
      expect(world.handlers.first.environments.first.behaviors).to match_array(%w[log])
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "behavior" do
    it "logs a hash in production" do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("production".inquiry)
      end
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history.first).to match(
        {
          message: /DEPRECATION WARNING: This is a dummy warning/,
          backtrace: [
            an_instance_of(String),
            an_instance_of(String),
            an_instance_of(String)
          ]
        }
      )
    end

    it "logs yaml in dev" do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("development".inquiry)
      end
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history.first).to match(
        ":message: 'DEPRECATION WARNING"
      )
    end
  end
end
