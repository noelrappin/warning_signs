module WarningSigns
  module MessageFormatter
    RSpec.describe Text do
      describe "#backtrace_filtered" do
        it "returns the backtrace without the ignored lines" do
          backtrace = [
            "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
            "/app/vendor/bundle/ruby/3.1.0/gems/activerecord-",
            "app/app/models/user.rb:1:in `<main>'"
          ]
          expect(described_class.new.filtered_backtrace(backtrace)).to eq([
            "app/app/models/user.rb:1:in `<main>'"
          ])
        end

        it "gracefully handles a nil backtrace" do
          expect(described_class.new.filtered_backtrace(nil)).to eq([])
        end

        it "returns the whole trace if everything would otherwise be filtered" do
          backtrace = %w[
            /app/vendor/bundle/ruby/3.1.0/gems/activesupport-
            /app/vendor/bundle/ruby/3.1.0/gems/activerecord-
          ]
          expect(described_class.new.filtered_backtrace(backtrace)).to eq(backtrace)
        end
      end

      describe "#filtered_backtrace_lines" do
        it "returns a blank string if the backtrace lines are zero" do
          backtrace = %w[
            /app/vendor/bundle/ruby/3.1.0/gems/activesupport-
            /app/vendor/bundle/ruby/3.1.0/gems/activerecord-
          ]
          expect(described_class.new.filtered_backtrace_lines(backtrace)).to eq([])
        end

        it "returns the given number of lines from the backtrace after the first line" do
          formatter = described_class.new(backtrace_lines: 2)
          backtrace = [
            "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
            "/app/vendor/bundle/ruby/3.1.0/gems/activerecord-",
            "app/app/models/user.rb:1:in `<main>'",
            "app/app/models/user.rb:2:in `<main>'",
            "app/app/models/user.rb:3:in `<main>'"
          ]
          expect(formatter.filtered_backtrace_lines(backtrace)).to eq(
            [
              "app/app/models/user.rb:2:in `<main>'",
              "app/app/models/user.rb:3:in `<main>'"
            ]
          )
        end
      end

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
            [
              "message",
              "app/app/models/user.rb:2:in `<main>'",
              "app/app/models/user.rb:3:in `<main>'"
            ]
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
            ["message"]
          )
        end
      end

      describe "#filtered_backtrace" do
        let(:backtrace) do
          [
            "/app/app/warning_signs/lib/text_spec.rb:1:in `<main>'",
            "<internal:tap>",
            "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
            "app/app/models/user.rb:1:in `<main>'"
          ]
        end

        it "filters the backtrace when in yes mode" do
          formatter = described_class.new(backtrace_lines: 2, filter_backtraces: "yes")
          expect(formatter.filtered_backtrace(backtrace)).to eq(
            ["app/app/models/user.rb:1:in `<main>'"]
          )
        end

        it "does not filter the backtrace when in no mode" do
          formatter = described_class.new(backtrace_lines: 2, filter_backtraces: "no")
          expect(formatter.filtered_backtrace(backtrace)).to eq(
            [
              "/app/app/warning_signs/lib/text_spec.rb:1:in `<main>'",
              "<internal:tap>",
              "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
              "app/app/models/user.rb:1:in `<main>'"
            ]
          )
        end

        it "partially filters the backtrace when in internals_only mode" do
          formatter = described_class.new(backtrace_lines: 2, filter_backtraces: "filter_internals")
          expect(formatter.filtered_backtrace(backtrace)).to eq(
            [
              "/app/vendor/bundle/ruby/3.1.0/gems/activesupport-",
              "app/app/models/user.rb:1:in `<main>'"
            ]
          )
        end
      end
    end
  end
end
