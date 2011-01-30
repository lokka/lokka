$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), 'lib')

if ENV['LOKKA_BUNDLE']
  ENV['GEM_HOME'] = File.expand_path(File.dirname(__FILE__), 'vendor/gem')
  $:.unshift File.expand_path(File.dirname(__FILE__), 'vendor/rubygems/lib')
  require 'rubygems'
else
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'lokka'
