#!/usr/bin/env ruby

def _run(cmd)
  puts cmd
  system cmd
end

Dir.chdir(File.dirname(__FILE__))

puts 'Show http://localhost:9292/'
_run 'bundle exec rackup'
