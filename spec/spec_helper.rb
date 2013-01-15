require 'bundler/setup'
Bundler.require(:default, :test)

PREFIX = /^\./

require_relative '../plugin_handler.rb'

ENV["MEETUP_API_KEY"] ||= "MEETUP_API_KEY"
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data("MEETUP_API_KEY") { ENV['MEETUP_API_KEY'] }
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
