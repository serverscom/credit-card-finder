# frozen_string_literal: true

require 'bundler/setup'
require 'credit_card_finder'

require 'webmock/rspec'
WebMock.allow_net_connect!
require 'vcr'
require 'pry-byebug'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  default_options = {match_requests_on: %i[method path body]}
  default_options[:record] = :all if ENV['VCR_UP']
  c.default_cassette_options = default_options
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
