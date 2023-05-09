module WarningSigns
  RSpec.describe World do
    let(:world) { WarningSigns::World.instance }

    before do
      world.clear
    end

    describe "handler matching" do
      it "returns the right handler in the simple case" do
        handler = Handler.new(environment: :all)
        world.handlers = [handler]
        deprecation = Deprecation.new("message", source: "ruby")
        expect(world.handler_for(deprecation)).to eq(handler)
      end
    end
  end
end
