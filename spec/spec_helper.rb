require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test
Lokka::Database.new.connect

module LokkaTestMethods
  def app
    @app ||= Lokka::App
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include LokkaTestMethods
end
