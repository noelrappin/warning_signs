# frozen_string_literal: true

# standard:disable Lint/NonDeterministicRequireOrder
# NOTE: The SimpleCov.start must be issued before any of your application code is required!
# see their documentation for more details: https://github.com/simplecov-ruby/simplecov
require "simplecov"
SimpleCov.start unless SimpleCov.running

require "active_support/all"
require "awesome_print"
require "pry"
require "rspec"
require "rspec/collection_matchers"
require "warning_signs"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = :random
  config.filter_gems_from_backtrace "bundler"
  config.default_formatter = "doc" if config.files_to_run.one?

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  Kernel.srand config.seed
end
# standard:enable Lint/NonDeterministicRequireOrder
