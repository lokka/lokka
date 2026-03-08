require './init'
require 'rake/testtask'

task default: ['test:setup', 'db:delete', :test]

desc 'Migrate the Lokka database'
task 'db:migrate' do
  puts 'Upgrading Database...'
  Lokka::Database.new.connect.migrate
end

desc 'Execute seed script'
task 'db:seed' do
  puts 'Initializing Database...'
  Lokka::Database.new.connect.seed
end

desc 'Delete database'
task 'db:delete' do
  puts 'Delete Database...'
  Lokka::Database.new.connect.migrate!
end

desc 'Reset database'
task 'db:reset' => %w[db:delete db:seed]

desc 'Set up database'
task 'db:setup' => %w[db:migrate db:seed]

desc 'Dump data from legacy DataMapper database to db/dm_dump.json (SOURCE=path_or_dsn)'
task 'db:dump_dm' do
  source = ENV['SOURCE']
  unless source
    puts 'Usage: rake db:dump_dm SOURCE=path/to/old/database.sqlite3'
    puts '       rake db:dump_dm SOURCE=postgres://user:pass@host/old_db'
    exit 1
  end
  require 'lokka/migrator'
  Lokka::DMMigrator.dump!(source)
end

desc 'Import dumped DataMapper data from db/dm_dump.json into the new database'
task 'db:import_dm' do
  require 'lokka/migrator'
  Lokka::Database.new.connect
  Lokka::DMMigrator.import!
end

desc 'Install gems'
task :bundle do
  `bundle install --path vendor/bundle --without production test`
end

desc 'Install'
task install: %w[bundle db:setup]

desc 'set ENV'
task 'test:setup' do
  ENV['RACK_ENV'] = ENV['LOKKA_ENV'] = 'test'
end

Rake::TestTask.new(test: 'test:setup') do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

namespace :admin do
  desc 'Install dependencies for admin JavaScript'
  task :install_deps do
    system('cd public/admin && npm install')
  end

  desc 'Build admin js'
  task :build_js => [:install_deps] do
    system('cd public/admin && npm run build')
  end
end
