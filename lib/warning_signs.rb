# frozen_string_literal: true

require "yaml"
require "rails/railtie"
require "active_support/all"
require "awesome_print"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module WarningSigns
  SAMPLE_CONSTANT = "foobar"

  class InvalidHandlerError < StandardError; end

  class RailsWarningError < StandardError; end
end

loader.eager_load
