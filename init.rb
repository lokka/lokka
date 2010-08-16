$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib')) 
require 'pyha'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Pathname(__FILE__).dirname.realpath}/db.sqlite3")
