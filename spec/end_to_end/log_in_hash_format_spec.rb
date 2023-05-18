RSpec.describe "with a simple file that logs everything" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/log_in_hash_format.yml")
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world.handlers.first.environments.first.environment).to be_all
      expect(world.handlers.first.environments.first.behaviors).to match_array(["log"])
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior" do
    it "does not write to standard error" do
      expect { Warning.warn("This is a dummy warning") }.not_to output.to_stderr
    end

    it "logs" do
      Warning.warn("This is a dummy warning")
      expect(Rails.logger.history.first).to match(
        {
          message: /RUBY WARNING: This is a dummy warning/,
          backtrace: [
            an_instance_of(String),
            an_instance_of(String),
            an_instance_of(String)
          ]
        }
      )
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

    it "does not raise an error" do
      expect { ActiveSupport::Deprecation.warn("This is a dummy warning") }.not_to raise_error
    end
  end
end
