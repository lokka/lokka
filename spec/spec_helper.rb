# frozen_string_literal: true

# require 'simplecov'
#
# SimpleCov.start do
#   add_filter 'spec/'
#   add_filter 'public/'
#   add_filter 'i18n/'
#   add_filter 'db/'
#   add_filter 'coverage/'
#   add_filter 'tmp/'
#   add_filter 'log/'
# end

require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'database_cleaner/active_record'

require 'factories'

set :environment, :test
Lokka::Database.connect
Lokka::Migrator.migrate!

module LokkaTestMethods
  def app
    @app ||= Lokka::App
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
  config.include LokkaTestMethods
  config.include Lokka::Helpers
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
    RequestStore.clear!
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
