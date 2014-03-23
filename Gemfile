source 'https://rubygems.org'

gem 'activerecord'
gem 'backports', '2.3.0'
gem 'bcrypt-ruby'
gem 'builder', '3.0.0'
gem 'bundler'
gem 'coderay', '1.0.5'
gem 'compass'
gem 'erubis', '~> 2.7.0'
gem 'haml', '~> 3.1.1'
gem 'i18n'
gem 'kaminari', '~> 0.14.0'
gem 'kramdown'
gem 'nokogiri', '~> 1.5.2'
gem 'rack'
gem 'rack-flash'
gem 'rake', '~> 0.9.2'
gem 'padrino-helpers', '~> 0.10.5'
gem 'redcarpet'
gem 'RedCloth', '4.2.9'
gem 'sass', '~> 3.1.1'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-flash'
gem 'slim', '~> 0.9.2'
gem 'stringex', '1.3.2'
gem 'tux'
gem 'wikicloth', '0.7.1'
gem 'yard-sinatra', '1.0.0'

Dir["public/plugin/lokka-*/Gemfile"].each {|path| eval(open(path) {|f| f.read }) }

group :production do
end

group :development do
  gem 'pry'
  gem 'sqlite3'
  gem 'tapp', '1.3.0'
end

group :development, :test do
  gem 'database_cleaner', '0.7.1'
  gem 'factory_girl',     '2.6.1'
  gem 'rack-test',        '0.6.1', require: 'rack/test'
  gem 'rspec',            '2.8.0'
  gem 'simplecov',        require: false
end

group :mysql do
  gem 'mysql2'
end

group :postgresql do
  gem 'pg'
end
