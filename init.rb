$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'plugin', 'hello', 'lib'))

require 'rubygems'
require 'bundler'
Bundler.setup
require 'pyha'
