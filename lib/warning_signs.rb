# frozen_string_literal: true

require "English"
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

  class UnhandledDeprecationError < StandardError; end
end

loader.eager_load
