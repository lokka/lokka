$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'bundler'
Bundler.setup
require 'lokka'
