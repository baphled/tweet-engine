# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require 'webmock/rspec'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers

  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec
end

def stub_get(path)
  stub_request(:get, Twitter.endpoint + path)
end

def fixture(file)
  File.read(File.expand_path("../fixtures", __FILE__) + '/' + file)
end


Twitter.configure do |config|
  config.consumer_key = "CK"
  config.consumer_secret = "CS"
  config.oauth_token = "OT"
  config.oauth_token_secret = "OTS"
end