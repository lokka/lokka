$:.unshift File.expand_path(File.dirname(__FILE__))
require 'init'

desc 'Create a table for plugin'
task 'db:migrate' do
  Redirect.auto_migrate!
end
