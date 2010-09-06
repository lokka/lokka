def _run(cmd)
  puts cmd
  system cmd
end

Dir.chdir(File.dirname(__FILE__))

_run 'gem update --system'
_run 'gem install bundler'
_run 'bundle install --without production test'
_run 'bundle exec rake db:reset'
