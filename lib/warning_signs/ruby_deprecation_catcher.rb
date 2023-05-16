module WarningSigns
  module RubyDeprecationCatcher
    include CallerLocationHelper
    def warn(message, category: nil)
      Deprecation.new(
        augmented_message(message, category),
        source: "ruby",
        category: category,
        backtrace: caller_locations
      ).invoke
    end

    def augmented_message(message, category)
      category_part = category.present? ? " #{category.upcase}: " : ": "
      "RUBY WARNING#{category_part}#{message} called from #{caller_locations_filtered.first}"
    end
  end
end
