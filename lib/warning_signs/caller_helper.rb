module WarningSigns
  module CallerHelper
    def caller_filtered
      caller.reject do |location|
        ignore_line(location.to_s)
      end
    end

    def ignore_line(line, filter_backtraces: "yes".inquiry)
      return false if filter_backtraces.no?
      partial_result = line.include?("<internal:") ||
        line.include?("warning_signs/lib")
      return partial_result if filter_backtraces.filter_internals?
      partial_result ||
        line.include?("rubygems") ||
        line.include?("/gems")
    end
  end
end
