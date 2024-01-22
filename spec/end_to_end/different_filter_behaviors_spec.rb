RSpec.describe "with a simple file that logs everything" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/different_filter_behaviors.yml")
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
    it "filters backtrace in production" do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("production".inquiry)
      end
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history).to have(4).elements
      expect(Rails.logger.history.first).to match("DEPRECATION WARNING: This is a dummy warning")
    end

    it "does not filter backtrace in development" do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("development".inquiry)
      end
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history).to have(4).elements
      expect(Rails.logger.history.first).to match("DEPRECATION WARNING: This is a dummy warning")
    end

    it "partially filters backtrace in test" do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("test".inquiry)
      end
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history).to have(4).elements
      expect(Rails.logger.history.first).to match("DEPRECATION WARNING: This is a dummy warning")
    end
  end
end
