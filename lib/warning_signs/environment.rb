module WarningSigns
  class Environment
    attr_accessor :environment, :behaviors

    def initialize(environment:, behaviors: [], behavior: nil)
      @environment = environment.to_s.downcase.inquiry
      @behaviors = (behaviors + [behavior])
        .compact
        .map { _1.to_s.downcase.inquiry }
    end
  end
end
