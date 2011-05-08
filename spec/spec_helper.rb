# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

module LokkaTestMethods
  def app
    @app ||= Lokka::App
  end
end

Rspec.configure do |config|
  config.include Rack::Test::Methods
  config.include LokkaTestMethods
end
