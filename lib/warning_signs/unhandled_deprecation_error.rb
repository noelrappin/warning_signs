module WarningSigns
  class UnhandledDeprecationError < StandardError
    MESSAGE = "This error was raised by the Warning Signs gem in response to a deprecation warning in Ruby or Rails. If this warning is not causing problems, you can add it to the exceptions list in .warning_signs.yml."

    def message
      super + "\n\n" + MESSAGE
    end
  end
end
