# frozen_string_literal: true

require "English"
require "yaml"
require "rails/railtie"
require "active_support/subscriber"
require "active_support/all"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module WarningSigns
  SAMPLE_CONSTANT = "foobar"

  class InvalidHandlerError < StandardError; end
end

loader.eager_load
