source 'https://rubygems.org'

gem 'bundler'
gem 'rack'
gem 'rack-flash'
gem 'sinatra-flash'
gem 'i18n'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'activerecord'
gem 'kaminari', '~> 0.14.0'
gem 'builder', '3.0.0'
gem 'haml', '~> 3.1.1'
gem 'sass', '~> 3.1.1'
gem 'compass'
gem 'slim', '~> 0.9.2'
gem 'rake', '~> 0.9.2'
gem 'erubis', '~> 2.7.0'
gem 'nokogiri', '~> 1.5.2'
gem 'tux'
gem 'padrino-helpers', '~> 0.10.5'
gem 'coderay', '1.0.5'
gem 'kramdown'
gem 'RedCloth', '4.2.9'
gem 'wikicloth', '0.7.1'
gem 'redcarpet'
gem 'yard-sinatra', '1.0.0'
gem 'stringex', '1.3.2'
gem 'backports', '2.3.0'

Dir["public/plugin/lokka-*/Gemfile"].each {|path| eval(open(path) {|f| f.read }) }

group :production do
end

group :development do
  gem 'tapp', '1.3.0'
  gem 'sqlite3'
  gem 'pry'
end

group :development, :test do
  gem 'rack-test', '0.6.1', :require => 'rack/test'
  gem 'rspec', '2.8.0'
  gem 'simplecov', :require => false if RUBY_VERSION >= '1.9'
  gem 'factory_girl', '2.6.1'
  gem 'database_cleaner', '0.7.1'
end

group :mysql do
  gem 'mysql2'
end
