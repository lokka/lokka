source 'https://rubygems.org'
ruby ">= 3.2"

gem 'activerecord', '~> 8.1'
gem 'activesupport', '~> 8.1'
gem 'sinatra', '~> 4.0'
gem 'sinatra-contrib', '~> 4.0'
gem 'sinatra-activerecord', '~> 2.0'
gem 'sinatra-flash', '~> 0.3.0'
gem 'kaminari', '~> 1.2'
gem 'kaminari-activerecord'
gem 'aws-sdk-s3'
gem 'builder'
gem 'bundler'
gem 'coderay'
gem 'haml', '~> 6.0'
gem 'kramdown'
gem 'marcel'
gem 'nokogiri'
gem 'padrino-helpers', '~> 0.16'
gem 'rack'
gem 'rack-session'
gem 'rake', '~> 13.0'
gem 'redcarpet'
gem 'RedCloth'
gem 'request_store'
gem 'slim', '~> 5.0'
gem 'tilt', '~> 2.0'

Dir['public/plugin/lokka-*/Gemfile'].each {|path| load(path) }

group :production do
  gem 'pg', '~> 1.5'
end

group :development, :test do
  gem 'sqlite3', '~> 2.0'
end

group :development do
  gem 'haml-lint'
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot', '~> 6.0'
  gem 'rack-test', '~> 2.0', require: 'rack/test'
  gem 'rspec', '~> 3.0'
  gem 'simplecov', require: false
end
gem 'csv'
gem 'ostruct'
gem 'rackup'
gem 'puma'
