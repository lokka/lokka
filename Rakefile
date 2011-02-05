require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "lokka"
  gem.homepage = "http://github.com/komagata/lokka"
  gem.license = "MIT"
  gem.summary = %Q{CMS for Cloud.}
  gem.description = %Q{CMS written in Ruby for cloud computing.}
  gem.email = "komagata@gmail.com"
  gem.authors = ["Masaki KOMAGATA", "Teppei Machida"]
  gem.executables = ['lokka']
  gem.files.exclude 'log'
  gem.files.exclude 'tmp'
  gem.add_dependency 'rack-flash', '0.1.1'
  gem.add_dependency 'i18n', '0.4.1'
  gem.add_dependency 'sinatra', '1.1.0'
  gem.add_dependency 'sinatra-r18n', '0.4.7.1'
  gem.add_dependency 'sinatra-content-for', '0.2'
  gem.add_dependency 'dm-migrations', '1.0.2'
  gem.add_dependency 'dm-timestamps', '1.0.2'
  gem.add_dependency 'dm-validations', '1.0.2'
  gem.add_dependency 'dm-types', '1.0.2'
  gem.add_dependency 'dm-is-tree', '1.0.2'
  gem.add_dependency 'dm-tags', '1.0.2'
  gem.add_dependency 'dm-pager', '1.1.0'
  gem.add_dependency 'builder', '2.1.2'
  gem.add_dependency 'haml', '3.0.18'
  gem.add_dependency 'rake', '0.8.7'
  gem.add_dependency 'exceptional', '2.0.25'
  gem.add_dependency 'erubis', '2.6.6'
  gem.add_dependency 'activesupport', '3.0.0'
  gem.add_dependency 'bluefeather', '0.33'
  gem.add_dependency 'dm-sqlite-adapter', '1.0.2'
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lokka #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

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

task 'package:mac' do
  puts ENV['MY_RUBY_HOME']
  system "cp -r #{ENV['MY_RUBY_HOME']} vendor/ruby"
  puts ENV['GEM_HOME']
  system "cp -r #{ENV['GEM_HOME']} vendor/gem"
end
