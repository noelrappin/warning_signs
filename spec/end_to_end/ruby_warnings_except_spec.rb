RSpec.describe "With an exception matcher" do
  let(:world) { WarningSigns::World.instance }

  before do
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("test".inquiry)
    end
    WarningSigns::World.from_file("spec/fixtures/ruby_warnings_except.yml")
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "Ruby behavior for no specified category" do
    it "does not write to standard error" do
      expect { Warning.warn("This is a dummy warning") }.not_to output.to_stderr
    end

    it "logs" do
      Warning.warn("This is a dummy warning", category: :deprecated)
      expect(Rails.logger.history).to have(1).element
      expect(Rails.logger.history.first).to match("RUBY WARNING DEPRECATED: This is a dummy warning")
    end

    it "does not raise an error" do
      expect { Warning.warn("This is a dummy warning") }.not_to raise_error
    end
  end

  describe "Ruby behavior for deprecated categories" do
    it "does not write to standard error" do
      expect { Warning.warn("This is a dummy warning", category: :deprecated) }.not_to output.to_stderr
    end

    it "does not log" do
      Warning.warn("This is a dummy warning")
      expect(Rails.logger.history).to be_empty
    end

    it "does not raise an error" do
      expect { Warning.warn("This is a dummy warning", category: :deprecated) }.not_to raise_error
    end
  end

  describe "Ruby behavior for experimental categories" do
    it "does not write to standard error" do
      expect { Warning.warn("This is a dummy warning", category: :experimental) }.not_to output.to_stderr
    end

    it "does not log" do
      Warning.warn("This is a dummy warning")
      expect(Rails.logger.history).to be_empty
    end

    it "does not raise an error" do
      expect { Warning.warn("This is a dummy warning", category: :experimental) }.not_to raise_error
    end
  end
end
