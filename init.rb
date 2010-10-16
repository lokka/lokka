require 'find'

$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

# plugins
Find.find(File.expand_path(File.join(File.dirname(__FILE__), 'plugin'))){|path|
	new_path = File.expand_path(File.join(path, 'lib'))
	$:.unshift new_path if File.directory?(new_path)
}

require 'rubygems'
require 'bundler'
Bundler.setup
require 'lokka'
