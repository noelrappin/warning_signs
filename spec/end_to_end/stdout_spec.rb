RSpec.describe "with a simple file that ignores everything", :block_stdout do
  let(:world) { WarningSigns::World.instance }

  before do
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
    WarningSigns::World.from_file("spec/fixtures/stdout.yml")
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world.handlers.first.environments.first.environment).to be_all
      expect(world.handlers.first.environments.first.behaviors).to match_array(["stdout"])
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior" do
    it "does not write to standard error" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }.not_to output.to_stderr
    end

    it "writes to standard out" do
      expect { Warning.warn("This is a dummy warning") }
        .to output(/RUBY WARNING: This is a dummy warning/)
        .to_stdout
    end

    it "does not log" do
      Warning.warn("This is a dummy warning")
      expect(Rails.logger.history).to be_empty
    end

    it "does not raise an error" do
      expect { Warning.warn("This is a dummy warning") }.not_to raise_error
    end
  end

  describe "Rails behavior" do
    it "does not write to standard error" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }.not_to output.to_stderr
    end

    it "writes to standard out" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }
        .to output(/DEPRECATION WARNING: This is a dummy warning/)
        .to_stdout
    end

    it "does not log" do
      RailsWarningEmitter.emit("This is a dummy warning")
      expect(Rails.logger.history).to be_empty
    end

    it "does not raise an error" do
      expect { RailsWarningEmitter.emit("This is a dummy warning") }.not_to raise_error
    end
  end
end
