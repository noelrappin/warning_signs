module WarningSigns
  RSpec.describe(Deprecation) do
    let(:world) { WarningSigns::World.instance }

    before do
      world.clear
      without_partial_double_verification do
        allow(Rails).to receive(:env).and_return("production".inquiry)
      end
    end

    describe "behavior" do
      it "returns the right handler and behavior in the default case" do
        handler = Handler.new(environment: :all)
        deprecation = Deprecation.new("message", source: "ruby")
        world.handlers = [handler]
        expect(deprecation.handler).to eq(handler)
        expect(deprecation.behaviors).to match_array([])
      end

      it "returns the right handler and behavior where there is behavior" do
        handler = Handler.new(environment: :all, behavior: :raise)
        deprecation = Deprecation.new("message", source: "ruby")
        world.handlers = [handler]
        expect(deprecation.handler).to eq(handler)
        expect(deprecation.behaviors).to match_array(["raise"])
      end

      it "ensures that raising is the last behavior if multiple behaviors" do
        handler = Handler.new(environment: :all, behaviors: %w[raise log])
        deprecation = Deprecation.new("message", source: "ruby")
        world.handlers = [handler]
        expect(deprecation.handler).to eq(handler)
        expect(deprecation.behaviors).to eq(%w[log raise])
      end
    end
  end
end
