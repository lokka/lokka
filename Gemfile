source 'https://rubygems.org'
ruby "~> 2.6"

gem 'activesupport', '~> 5.2'
gem 'activerecord', '~> 5.2'
gem 'sinatra-activerecord', '~> 2.0'
gem 'kaminari', '~> 1.2'
gem 'kaminari-activerecord'
gem 'aws-sdk-s3'
gem 'backports', '2.3.0'
gem 'builder'
gem 'bundler'
gem 'coderay', '1.0.5'
gem 'coffee-script'
gem 'compass'
gem 'erubis', '~> 2.7.0'
gem 'haml', '~> 5.0'
gem 'i18n', '~> 0.7'
gem 'kramdown'
gem 'marcel'
gem 'nokogiri'
gem 'padrino-helpers', '~> 0.14.1.1'
gem 'rack'
gem 'rack-flash', '~> 0.1.2'
gem 'rake', '~> 12.3'
gem 'redcarpet'
gem 'RedCloth', '4.2.9'
gem 'request_store'
gem 'sass'
gem 'sinatra', '~> 1.4.2'
gem 'sinatra-contrib', '~> 1.4.0'
gem 'sinatra-flash', '~> 0.3.0'
gem 'slim', '~> 3.0.7'
gem 'tilt', '~> 2.0'
gem 'tux'
gem 'yard-sinatra', '1.0.0'

Dir['public/plugin/lokka-*/Gemfile'].each {|path| load(path) }

group :production do
  gem 'pg', '~> 1.0'
end

group :development, :test do
  gem 'tapp', '1.3.0'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'haml-lint'
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner', '0.7.1'
  gem 'factory_girl', '~> 4.0'
  gem 'rack-test', '0.6.1', require: 'rack/test'
  gem 'rspec', '~> 2.0'
  gem 'simplecov', require: false
end
