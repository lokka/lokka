$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'bundler'
Bundler.require
require 'pyha'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{File.expand_path('..', __FILE__)}/db.sqlite3")
