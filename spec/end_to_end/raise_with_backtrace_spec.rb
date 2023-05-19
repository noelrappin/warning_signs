RSpec.describe "with a simple file that raises on everything" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/raise_with_backtrace.yml")
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world.handlers.first.environments.first.environment).to be_all
      expect(world.handlers.first.environments.first.behaviors).to match_array(["raise"])
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior" do
    it "does not write to standard error" do
      expect do
        Warning.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end.not_to output.to_stderr
    end

    it "does not log" do
      begin
        Warning.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end
      expect(Rails.logger.history).to be_empty
    end

    it "raises an error" do
      expect { Warning.warn("This is a dummy warning") }.to raise_error(WarningSigns::UnhandledDeprecationError)
    end

    it "prints a filtered backtrace" do
      Warning.warn("This is a dummy warning")
    rescue WarningSigns::UnhandledDeprecationError
      expect($ERROR_POSITION).to have_at_most(5).lines
    end
  end

  describe "Rails behavior" do
    it "does not write to standard error" do
      expect do
        ActiveSupport::Deprecation.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end.not_to output.to_stderr
    end

    it "does not log" do
      begin
        Warning.warn("This is a dummy warning")
      rescue WarningSigns::UnhandledDeprecationError
      end
      expect(Rails.logger.history).to be_empty
    end

    it "prints a filtered backtrace" do
      Warning.warn("This is a dummy warning")
    rescue WarningSigns::UnhandledDeprecationError
      expect($ERROR_POSITION).to have_at_most(5).lines
    end
  end
end
