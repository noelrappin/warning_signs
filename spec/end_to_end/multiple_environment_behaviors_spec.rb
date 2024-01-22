RSpec.describe "With an exception matcher" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file(
      "spec/fixtures/multiple_environment_behaviors.yml"
    )
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "in production" do
    before do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("production".inquiry)
      end
    end

    it "does not write to standard error" do
      expect { Warning.warn("This is a dummy warning") }.not_to output.to_stderr
    end

    it "does not log" do
      Warning.warn("This is a dummy warning")
      expect(Rails.logger.history).to be_empty
    end

    it "does not raise an error" do
      expect { Warning.warn("This is a dummy warning") }.not_to raise_error
    end
  end

  describe "in development" do
    before do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("development".inquiry)
      end
    end

    it "does not write to standard error" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }.not_to output.to_stderr
    end

    it "logs" do
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history.first).to match("DEPRECATION WARNING: This is a dummy warning")
    end

    it "does not raise an error" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }.not_to raise_error
    end
  end

  describe "in test" do
    before do
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("test".inquiry)
      end
    end

    it "does not write to standard error" do
      expect do
        Warning.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end.not_to output.to_stderr
    end

    it "logs" do
      begin
        Warning.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end
      expect(Rails.logger.history.first).to match("RUBY WARNING: This is a dummy warning")
    end

    it "raises an error" do
      expect { Warning.warn("This is a dummy warning") }.to raise_error(WarningSigns::UnhandledDeprecationError)
    end
  end
end
