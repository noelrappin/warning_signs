module WarningSigns
  class RubyCategoryMatcher
    attr_accessor :only, :except

    def initialize(only: [], except: [])
      @only = only.compact.map { _1.to_sym }
      @except = except.compact.map { _1.to_sym }
    end

    def match?(category)
      category = :blank if category.blank?
      only_match?(category) && except_match?(category)
    end

    def only_match?(category)
      return true if only.empty?
      only.any? do |only_pattern|
        only_pattern === category&.to_sym
      end
    end

    def except_match?(category)
      return true if except.empty?
      except.none? do |except_pattern|
        except_pattern === category&.to_sym
      end
    end
  end
end
