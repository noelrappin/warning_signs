module WarningSigns
  module CallerLocationHelper
    def caller_location_start
      caller_locations.find_index do |location|
        !ignore_line(location.to_s)
      end || 0
    end

    def ignore_line(line)
      line.include?("<internal:") ||
        line.include?("warning_signs/lib") ||
        line.include?("warning_signs/spec") ||
        line.include?("rubygems") ||
        line.include?("/gems")
    end
  end
end
