RSpec.describe "with a file that sends everything to standard out" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/source.yml")
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(2).handler
      expect(world.handlers.first.source).to be_ruby
      expect(world.handlers.second.source).to be_rails
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior" do
    it "writes to standard error" do
      expect { Warning.warn("This is a dummy warning") }
        .to output(/RUBY DEPRECATION WARNING: This is a dummy warning/)
        .to_stderr
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
      expect { ActiveSupport::Deprecation.warn("This is a dummy warning") }.not_to output.to_stderr
    end

    it "logs" do
      ActiveSupport::Deprecation.warn("This is a dummy warning")
      expect(Rails.logger.history.first).to match("DEPRECATION WARNING: This is a dummy warning")
    end

    it "does not raise an error" do
      expect { ActiveSupport::Deprecation.warn("This is a dummy warning") }.not_to raise_error
    end
  end
end
