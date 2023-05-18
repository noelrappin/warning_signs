RSpec.describe "with a simple file that logs everything" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/multiple_formatters.yml")
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world.handlers.first.environments.first.environment).to be_all
      expect(world.handlers.first.environments.first.behaviors).to match_array(%w[log raise stderr])
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior" do
    it "writes text to standard error" do
      result = StringIO.new
      $stderr = result
      Warning.warn("This is a dummy warning")
    rescue WarningSigns::UnhandledDeprecationError
      expect(result.string).to match(/RUBY WARNING: This is a dummy warning/)
      expect(result.string).not_to match(/:backtrace=>/)
    end

    it "logs" do
      ActiveSupport::Deprecation.warn("This is a dummy warning")
    rescue WarningSigns::UnhandledDeprecationError
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

    it "raises an error" do
      expect { Warning.warn("This is a dummy warning") }.to raise_error(WarningSigns::UnhandledDeprecationError)
    end

    it "prints an entire backtrace" do
      Warning.warn("This is a dummy warning")
    rescue WarningSigns::UnhandledDeprecationError
      expect($ERROR_POSITION).to have_at_least(4).items
    end
  end
end
