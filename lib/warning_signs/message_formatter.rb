module WarningSigns
  class MessageFormatter
    include CallerLocationHelper
    attr_reader :backtrace_lines

    def initialize(backtrace_lines: 0)
      @backtrace_lines = backtrace_lines
    end

    def filtered_backtrace(backtrace)
      return [] if backtrace.nil?
      result = backtrace.reject do |location|
        ignore_line(location.to_s)
      end
      result.empty? ? backtrace : result
    end

    def filtered_backtrace_lines(backtrace)
      return "" if backtrace_lines.zero?
      lines = filtered_backtrace(backtrace)[1..backtrace_lines] || []
      lines.join("\n")
    end
  end
end
