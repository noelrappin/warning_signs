module WarningSigns
  RSpec.describe UnhandledDeprecationError do
    it "handles warnings" do
      exe = UnhandledDeprecationError.new("Feature x is going away")
      expect(exe.message.ends_with?("exceptions list in .warning_signs.yml.")).to be_truthy
    end
  end
end
