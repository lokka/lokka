#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__))
exec 'bundle exec rackup -p 9646'
