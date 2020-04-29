require './init'
require 'yard'
include Rake::DSL if defined? Rake::DSL

task :default => ['spec:setup', 'db:delete', :spec]

desc 'Migrate the Lokka database'
task 'db:migrate' do
  puts 'Upgrading Database...'
  Lokka::Migrator.migrate!
end

desc 'Execute seed script'
task 'db:seed' do
  puts 'Initializing Database...'
  Lokka::Migrator.seed!
end

#FIXME
desc 'Delete database'
task 'db:delete' do
  puts 'Delete Database...'
  #Lokka::Database.new.connect.migrate!
end

desc 'Reset database'
task 'db:reset' => %w(db:delete db:seed)

desc 'Set up database'
task 'db:setup' => %w(db:migrate db:seed)

desc 'Lokka console'
task 'console' do
  require 'pry'
  require 'lib/lokka'
  #Lokka::Database.connect
  Pry.start
end

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

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec => 'spec:setup') do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = ['-cfs']
  end
  namespace :spec do
    RSpec::Core::RakeTask.new(:unit => 'spec:setup') do |t|
      t.pattern = 'spec/unit/**/*_spec.rb'
      t.rspec_opts = ['-c']
    end

    RSpec::Core::RakeTask.new(:integration => 'spec:setup') do |t|
      t.pattern = "spec/integration/**/*_spec.rb"
      t.rspec_opts = ['-c']
    end
  end
rescue LoadError => e
end
