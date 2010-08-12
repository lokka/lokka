$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require '.bundle/environment'
require 'pyha'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/db.sqlite3")

desc 'Create the Pyha database'
task 'db:migrate' do
  DataMapper.auto_migrate!
end

desc 'Execute seed script'
task 'db:seed' do
  require 'db/seed'
end

desc 'Reset database'
task 'db:reset' => %w(db:migrate db:seed)

desc 'Bundler'
task :bundle do
  `bundle install bundle  --without production`
end

desc 'Rebundler'
task :rebundle do
  `bundle install bundle --without production --relock`
end

desc 'Install'
task :install => %w(bundle db:reset)

desc 'Reinstall'
task :reinstall => %w(rebundle db:reset)
