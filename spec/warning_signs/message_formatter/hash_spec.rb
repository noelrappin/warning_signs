module WarningSigns
  module MessageFormatter
    RSpec.describe Hash do
      describe "#format" do
        it "formats a message with a backtrace" do
          formatter = described_class.new(backtrace_lines: 2)
          backtrace = [
            "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
            "/app/vendor/bundle/ruby/3.1.0/gems/activerecord-",
            "app/app/models/user.rb:1:in `<main>'",
            "app/app/models/user.rb:2:in `<main>'",
            "app/app/models/user.rb:3:in `<main>'"
          ]
          expect(formatter.format_message("message", backtrace)).to eq(
            {
              message: "message",
              backtrace: [
                "app/app/models/user.rb:2:in `<main>'",
                "app/app/models/user.rb:3:in `<main>'"
              ]
            }
          )
        end

        it "skips the backtrace if not asked for it" do
          formatter = described_class.new
          backtrace = [
            "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
            "/app/vendor/bundle/ruby/3.1.0/gems/activerecord-",
            "app/app/models/user.rb:1:in `<main>'",
            "app/app/models/user.rb:2:in `<main>'",
            "app/app/models/user.rb:3:in `<main>'"
          ]
          expect(formatter.format_message("message", backtrace)).to eq(
            {
              message: "message",
              backtrace: []
            }
          )
        end
      end
    end
  end
end
