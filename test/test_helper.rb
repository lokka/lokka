# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter 'test/'
  add_filter 'public/'
  add_filter 'i18n/'
  add_filter 'db/'
  add_filter 'coverage/'
  add_filter 'tmp/'
  add_filter 'log/'
end

ENV['RACK_ENV'] = ENV['LOKKA_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'minitest/autorun'
require 'factory_bot'
require 'database_cleaner/active_record'

require_relative 'factories'

set :environment, :test
db = Lokka::Database.new.connect
db.migrate!

module LokkaTestMethods
  def app
    @app ||= Lokka::App
  end
end

class LokkaTestCase < Minitest::Test
  include Rack::Test::Methods
  include LokkaTestMethods
  include Lokka::Helpers
  include FactoryBot::Syntax::Methods

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    RequestStore.clear!
  end

  def teardown
    DatabaseCleaner.clean
  end
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end
