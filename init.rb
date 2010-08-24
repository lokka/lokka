$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'bundler/setup'
require 'pyha'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{File.expand_path('..', __FILE__)}/db.sqlite3")
