$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
puts File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)
require 'test/unit'
require 'pyha'

module TestHelper
  include Rack::Test::Methods

  def app
    Pyha::App
  end
end

Test::Unit::TestCase.send(:include, TestHelper)
