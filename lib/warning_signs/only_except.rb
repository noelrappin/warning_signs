module WarningSigns
  class OnlyExcept
    attr_accessor :only, :except

    def initialize(only: [], except: [])
      @only = only
      @except = except
    end

    def only_except_match?(message)
      only_match?(message) && except_match?(message)
    end

    def only_match?(message)
      return true if only.empty?
      only.any? do |only_pattern|
        only_pattern.match?(message)
      end
    end

    def except_match?(message)
      return true if except.empty?
      except.none? do |except_pattern|
        except_pattern.match?(message)
      end
    end

    def valid?
      except.empty? || only.empty?
    end
  end
end
