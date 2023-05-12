module WarningSigns
  RSpec.describe CallerLocationHelper do
    class CallerLocationHelperTester
      include CallerLocationHelper
    end

    let(:tester) { CallerLocationHelperTester.new }

    it "can find the start of the caller location" do
      expect(tester.ignore_line("/Users/noel/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/rspec-expectations-3.12.3/lib/rspec/matchers/built_in/raise_error.rb:59:in `matches?'")).to be_truthy
      expect(tester.ignore_line("/home/runner/work/warning_signs/warning_signs/vendor/bundle/ruby/3.2.0/gems/rspec-core-3.12.2/lib/rspec/core/example.rb:263:in `instance_exec'")).to be_truthy
    end
  end
end
