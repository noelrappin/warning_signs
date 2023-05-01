module WarningSigns
  RSpec.describe(Handler) do
    describe "source match" do
      it "matches anything real if it is any" do
        handler = Handler.new(source: "any")
        expect(handler.source_match?("ruby".inquiry)).to be_truthy
        expect(handler.source_match?("rails".inquiry)).to be_truthy
        expect(handler.source_match?("unknown".inquiry)).to be_falsey
        expect(handler.source_match?(nil)).to be_falsey
      end

      it "matches ruby" do
        handler = Handler.new(source: "ruby")
        expect(handler.source_match?("ruby".inquiry)).to be_truthy
        expect(handler.source_match?("rails".inquiry)).to be_falsey
        expect(handler.source_match?("unknown".inquiry)).to be_falsey
        expect(handler.source_match?(nil)).to be_falsey
      end

      it "matches rails" do
        handler = Handler.new(source: "rails")
        expect(handler.source_match?("ruby".inquiry)).to be_falsey
        expect(handler.source_match?("rails".inquiry)).to be_truthy
        expect(handler.source_match?("unknown".inquiry)).to be_falsey
        expect(handler.source_match?(nil)).to be_falsey
      end
    end

    describe "pattern matching" do
      it "matches all strings if no restrictions are specified" do
        handler = Handler.new
        expect(handler.pattern_match?("Class level methods are blowing up")).to be_truthy
        expect(handler.pattern_match?("Instance level methods are blowing up")).to be_truthy
      end

      it "correctly matches strings in the only case" do
        handler = Handler.new(only: ["Class level methods"])
        expect(handler.pattern_match?("Class level methods are blowing up")).to be_truthy
        expect(handler.pattern_match?("Instance level methods are blowing up")).to be_falsey
      end

      it "correctly matches strings in the except case" do
        handler = Handler.new(except: ["Class level methods"])
        expect(handler.pattern_match?("Class level methods are blowing up")).to be_falsey
        expect(handler.pattern_match?("Instance level methods are blowing up")).to be_truthy
      end
    end
  end
end
