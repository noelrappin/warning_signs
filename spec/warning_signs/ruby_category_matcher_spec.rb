module WarningSigns
  RSpec.describe(RubyCategoryMatcher, :aggregate_failures) do
    describe "with nothing declared matches everything" do
      it "matches everything with nothing declared" do
        matcher = RubyCategoryMatcher.new
        expect(matcher.match?("")).to be_truthy
        expect(matcher.match?(nil)).to be_truthy
        expect(matcher.match?(:deprecated)).to be_truthy
        expect(matcher.match?(:experimental)).to be_truthy
        expect(matcher.match?(:blank)).to be_truthy
      end

      it "matches correctly with only deprecated" do
        matcher = RubyCategoryMatcher.new(only: [:deprecated])
        expect(matcher.match?("")).to be_falsey
        expect(matcher.match?(nil)).to be_falsey
        expect(matcher.match?(:deprecated)).to be_truthy
        expect(matcher.match?("deprecated")).to be_truthy
        expect(matcher.match?(:experimental)).to be_falsey
        expect(matcher.match?(:blank)).to be_falsey
      end

      it "matches correctly with only blank" do
        matcher = RubyCategoryMatcher.new(only: [:blank])
        expect(matcher.match?("")).to be_truthy
        expect(matcher.match?(nil)).to be_truthy
        expect(matcher.match?(:deprecated)).to be_falsey
        expect(matcher.match?("deprecated")).to be_falsey
        expect(matcher.match?(:experimental)).to be_falsey
        expect(matcher.match?(:blank)).to be_truthy
      end

      it "matches correctly with except deprecated" do
        matcher = RubyCategoryMatcher.new(except: [:deprecated])
        expect(matcher.match?("")).to be_truthy
        expect(matcher.match?(nil)).to be_truthy
        expect(matcher.match?(:deprecated)).to be_falsey
        expect(matcher.match?("deprecated")).to be_falsey
        expect(matcher.match?(:experimental)).to be_truthy
        expect(matcher.match?(:blank)).to be_truthy
      end

      it "matches correctly with except blank" do
        matcher = RubyCategoryMatcher.new(except: [:blank])
        expect(matcher.match?("")).to be_falsey
        expect(matcher.match?(nil)).to be_falsey
        expect(matcher.match?(:deprecated)).to be_truthy
        expect(matcher.match?("deprecated")).to be_truthy
        expect(matcher.match?(:experimental)).to be_truthy
        expect(matcher.match?(:blank)).to be_falsey
      end
    end
  end
end
