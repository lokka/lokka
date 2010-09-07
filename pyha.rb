def _run(cmd)
  puts cmd
  system cmd
end

Dir.chdir(File.dirname(__FILE__))

puts 'Show http://localhost:9393/'
_run 'bundle exec shotgun'
