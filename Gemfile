source 'https://rubygems.org'
ruby "~> 2.4"

gem 'activerecord'
gem 'kaminari-sinatra'
gem 'activesupport', '~> 5.0'
gem 'bcrypt'
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
gem 'mimemagic'
gem 'nokogiri'
gem 'padrino-helpers', '~> 0.14.1.1'
gem 'rack'
gem 'rack-flash', '~> 0.1.2'
gem 'rake', '~> 12.3'
gem 'redcarpet'
gem 'RedCloth', '4.2.9'
gem 'request_store'
gem 'sass', '< 3.5'
gem 'sinatra', '~> 1.4.2'
gem 'sinatra-contrib', '~> 1.4.0'
gem 'sinatra-flash', '~> 0.3.0'
gem 'slim', '~> 3.0.7'
gem 'tilt', '~> 2.0'
gem 'tux'
gem 'yard-sinatra', '1.0.0'

Dir['public/plugin/lokka-*/Gemfile'].each {|path| load(path) }

group :production do
end

group :development do
  gem 'pry'
  gem 'sqlite3'
  gem 'tapp', '1.3.0'
end

group :development, :test do
  gem 'database_cleaner-active_record'
  gem 'factory_girl',     '~> 4.0'
  gem 'rack-test',        '0.6.1', require: 'rack/test'
  gem 'rspec',            '~> 2.99'
  gem 'simplecov',        require: false
end

group :mysql do
  gem 'mysql2'
end

group :postgresql do
  gem 'pg'
end
