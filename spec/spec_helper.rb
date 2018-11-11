# frozen_string_literal: true

require 'bundler/setup'
require 'coin_market_pro'
require 'simplecov'
require 'webmock/rspec'
require 'pry'

SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    allow(Logger).to receive(:new).and_return(double('Logger', debug: nil, error: nil, warn: nil))
  end
end

# Return fixture relative to './spec/fixtures'
def fixture(file_name, json: false, symbolize: false)
  file = File.read("./spec/fixtures/#{file_name}")
  return file unless json

  JSON.parse(file, symbolize_names: symbolize)
end
