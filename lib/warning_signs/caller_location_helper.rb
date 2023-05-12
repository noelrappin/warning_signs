module WarningSigns
  module CallerLocationHelper
    def caller_location_start
      ap caller_locations.map { |location| location.to_s }
      caller_locations.find_index do |location|
        !location.to_s.include?("<internal:") &&
          !location.to_s.include?("warning_signs") &&
          !location.to_s.include?("rubygems") &&
          !location.to_s.include?("/gems")
      end || 0
    end
  end
end
