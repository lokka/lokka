if RUBY_VERSION >= '1.9'

  require 'simplecov'

  SimpleCov.start do
    add_filter "spec/"
    add_filter "public/"
    add_filter "i18n/"
    add_filter "db/"
    add_filter "coverage/"
    add_filter "tmp/"
    add_filter "log/"
  end
end

require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'factory_girl'

require 'factories'


set :environment, :test
Lokka::Database.new.connect

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
end
