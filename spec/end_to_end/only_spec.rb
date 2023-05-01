RSpec.describe "With an only matcher" do
  let(:world) { WarningSigns::World.instance }

  before do
    WarningSigns::World.from_file("spec/fixtures/only.yml")
    without_partial_double_verification do
      allow(Rails).to receive(:env).and_return("production".inquiry)
    end
  end

  describe "initialization" do
    it "sets up the world" do
      expect(world).to have(1).handler
      expect(world).to be_enabled_for_ruby
      expect(world).to be_enabled_for_rails
    end
  end

  describe "matching" do
    it "raises an error on a non-excepted match" do
      expect { Warning.warn("Only this one") }
        .to raise_error(WarningSigns::RailsWarningError)
    end

    it "does not raise an error on an excepted match" do
      expect { Warning.warn("Except this one") }
        .not_to raise_error
    end
  end
end
