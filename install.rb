#!/usr/bin/env ruby

def _run(cmd)
  puts cmd
  system cmd
end

Dir.chdir(File.dirname(__FILE__))

_run 'gem update --system'
_run 'gem install bundler --no-rdoc --no-ri --version "1.0.0"'
_run 'bundle install bundle --without production test'
_run 'bundle exec rake db:reset'
puts '--- Installation complete ---'
puts 'Press Enter.'
STDIN.getc
