#!/usr/bin/env ruby

def _run(cmd)
  puts cmd
  system cmd
end

Dir.chdir(File.dirname(__FILE__))

_run 'gem update --system'
_run 'gem install bundler --no-rdoc --no-ri'
_run 'bundle install --without production'
_run 'bundle exec rake db:set'
puts '--- Installation complete ---'
puts 'Press Enter.'
STDIN.getc
