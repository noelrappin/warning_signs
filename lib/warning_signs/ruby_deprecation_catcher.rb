module WarningSigns
  module RubyDeprecationCatcher
    include CallerLocationHelper
    def warn(message, category: nil)
      p "RubyDeprecationCatcher.warn"
      p caller_location_start
      p caller_locations[caller_location_start]
      Deprecation.new(
        augmented_message(message, category),
        source: "ruby",
        category: category,
        backtrace: caller_locations[caller_location_start..]
      ).invoke
    end

    def augmented_message(message, category)
      category_part = category.present? ? " #{category.upcase}: " : ": "
      "RUBY WARNING#{category_part}#{message} called from #{caller_locations[caller_location_start]}"
    end
  end
end
