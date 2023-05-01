module WarningSigns
  module RubyDeprecationCatcher
    def warn(message)
      Deprecation.new(augmented_message(message), source: "ruby").invoke
    end

    def augmented_message(message)
      "RUBY DEPRECATION WARNING: #{message} called from #{caller_locations(2..2).first}"
    end
  end
end
