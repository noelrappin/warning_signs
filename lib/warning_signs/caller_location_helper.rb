module WarningSigns
  module CallerLocationHelper
    def caller_location_start
      caller_locations.find_index do |location|
        !location.to_s.include?("<internal:") &&
          !location.to_s.include?("warning_signs") &&
          !location.to_s.include?("rubygems") &&
          !location.to_s.include?("/gems")
      end || 0
    end
  end
end
