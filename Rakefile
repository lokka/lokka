require './init'

desc 'Prepare test'
task 'test:prepare' => 'db:migrate' do
  Lokka::Database.new.connect.seed
end

desc 'Migrate the Lokka database'
task 'db:migrate' do
  puts 'Upgrading Database...'
  Lokka::Database.new.connect.migrate
end

desc 'Execute seed script'
task 'db:seed' do
  puts 'Initializing Database...'
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.logger.set_log STDERR, :debug, "SQL: ", true
  Lokka::Database.new.connect.seed
end

desc 'Delete database'
task 'db:delete' do
  puts 'Delete Database...'
  Lokka::Database.new.connect.migrate!
end

desc 'Reset database'
task 'db:reset' => %w(db:delete db:seed)

desc 'Set database'
task 'db:set' => %w(db:migrate db:seed)

desc 'Install gems'
task :bundle do
  `bundle install --path vendor/bundle --without production test`
end

desc 'Install'
task :install => %w(bundle db:set)
