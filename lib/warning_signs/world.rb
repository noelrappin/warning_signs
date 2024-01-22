module WarningSigns
  class World
    include Singleton
    attr_accessor :handlers

    def self.from_file(filename)
      from_hash(YAML.load_file(filename))
    end

    def self.from_hash(hash)
      instance.clear
      instance.handlers = hash["handlers"].map { Handler.from_hash(_1) }
      instance.one_time_set_up
      instance
    end

    def initialize
      @initialized = false
      clear
    end

    def handler_for(deprecation)
      handlers.find { _1.match?(deprecation) }
    end

    def clear
      @handlers = []
    end

    def enabled_for_rails?
      handlers.any? { !_1.enabled_for_rails? }
    end

    def enabled_for_ruby?
      handlers.any? { !_1.enabled_for_ruby? }
    end

    def one_time_set_up
      return if @initialized
      ruby_set_up
      rails_set_up
      @initialized = true
    end

    def ruby_set_up
      Warning[:deprecated] = true
      Warning.extend(WarningSigns::RubyDeprecationCatcher)
    end

    def rails_set_up
      if ActiveSupport.version >= Gem::Version.new("7.1.0")
        Rails.application.deprecators.behavior = :notify
      else
        ActiveSupport::Deprecation.behavior = :notify
      end
    end
  end
end
