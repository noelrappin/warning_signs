module WarningSigns
  module RubyDeprecationCatcher
    def warn(message, category: nil)
      Deprecation.new(
        augmented_message(message, category),
        source: "ruby",
        category: category
      ).invoke
    end

    def augmented_message(message, category)
      category_part = category.present? ? " #{category.upcase}: " : ": "
      "RUBY WARNING#{category_part}#{message} called from #{caller_location}"
    end

    def caller_location
      caller_locations.find do |location|
        !location.to_s.include?("internal:warning") &&
          !location.to_s.include?("warning_signs") &&
          !location.to_s.include?("rubygems") &&
          !location.to_s.include?("/gems")
      end
    end
  end
end
