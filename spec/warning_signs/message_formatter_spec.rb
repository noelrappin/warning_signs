module WarningSigns
  RSpec.describe MessageFormatter do
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
        expect(described_class.new.filtered_backtrace_lines(backtrace)).to eq("")
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
          "app/app/models/user.rb:2:in `<main>'\napp/app/models/user.rb:3:in `<main>'"
        )
      end
    end
  end
end
