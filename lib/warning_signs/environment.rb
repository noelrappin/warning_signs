module WarningSigns
  class Environment
    attr_accessor :environment, :behavior

    def initialize(environment:, behavior:)
      @environment = environment.to_s.downcase.inquiry
      @behavior = behavior.to_s.downcase.inquiry
    end
  end
end
