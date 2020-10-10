# frozen_string_literal: true

require "bundler/setup"
require 'dotenv'
require "eltiempo"
require 'vcr'

# Loading environment variables
Dotenv.load

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Retrieves the recorded responses if they're not already in the
# specified location
VCR.configure do |config|
  config.config_cassette_library_dir = 'spec/fixtures/eltiempo'
  config.hook_into :webmock
end
