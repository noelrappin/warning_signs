module WarningSigns
  module RubyDeprecationCatcher
    def warn(message)
      Deprecation.new(augmented_message(message), source: "ruby").invoke
    end

    def augmented_message(message)
      "RUBY DEPRECATION WARNING: #{message} called from #{caller_location}"
    end

    def caller_location
      caller_locations(2..).find do |location|
        !location.to_s.includes?("internal:warning")
      end
    end
  end
end
