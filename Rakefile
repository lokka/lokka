require './init'
require 'yard'
include Rake::DSL if defined? Rake::DSL

task :default => ['spec:setup', 'db:delete', 'db:spec_seed', :spec]

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
task 'db:setup' => %w(db:migrate db:seed)

desc 'Install gems'
task :bundle do
  `bundle install --path vendor/bundle --without production test`
end

desc 'Install'
task :install => %w(bundle db:setup)

desc 'Generate documentation for Lokka'
task :doc do
  YARD::CLI::Yardoc.new.run
end

desc 'set ENV'
task 'spec:setup' do
  ENV['RACK_ENV'] = ENV['LOKKA_ENV'] = 'test'
end

desc 'Execute spec seed script'
task 'db:spec_seed' do
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.logger.set_log STDERR, :debug, "SQL: ", true
  Lokka::Database.new.connect
  load File.join(Lokka.root, 'db', 'spec_seeds.rb')
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec => 'spec:setup') do |spec|
    spec.pattern = 'spec/*_spec.rb'
    spec.rspec_opts = ['-cfs']
  end
rescue LoadError => e
end
