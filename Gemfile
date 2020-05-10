# frozen_string_literal: true

source 'https://rubygems.org'
ruby '~> 2.4'

gem 'activerecord'
gem 'activesupport', '~> 5.0'
gem 'awesome_print'
gem 'aws-sdk-s3'
gem 'backports'
gem 'bcrypt'
gem 'builder'
gem 'bundler'
gem 'coderay'
gem 'coffee-script'
gem 'compass'
gem 'erubis'
gem 'haml'
gem 'i18n'
gem 'kaminari-activerecord'
gem 'kaminari-sinatra'
gem 'kramdown'
gem 'mimemagic'
gem 'nokogiri'
gem 'padrino-helpers'
gem 'pry'
gem 'rack'
gem 'rack-flash'
gem 'rake'
gem 'redcarpet'
gem 'RedCloth'
gem 'request_store'
gem 'sass', '< 3.5'
gem 'sinatra', '~> 1.4'
gem 'sinatra-contrib'
gem 'sinatra-flash'
gem 'slim'
gem 'tilt'
gem 'tux'
gem 'yard-sinatra'

Dir['public/plugin/lokka-*/Gemfile'].each {|path| load(path) }

group :development do
  gem 'rubocop'
  gem 'sqlite3'
  gem 'tapp'
end

group :development, :test do
  gem 'database_cleaner-active_record'
  gem 'factory_girl', '~> 4.0'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec', '~> 2.99'
  gem 'simplecov', require: false
end

group :mysql do
  gem 'mysql2'
end

group :postgresql do
  gem 'pg'
end
