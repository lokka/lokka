source 'https://rubygems.org'

gem 'activesupport', '~> 4.2'
gem 'aws-sdk-s3'
gem 'backports', '2.3.0'
gem 'builder'
gem 'bundler'
gem 'coderay', '1.0.5'
gem 'coffee-script'
gem 'compass'
gem 'data_objects',     '0.10.17'
gem 'dm-aggregates',    '~> 1.2.0'
gem 'dm-core',          '~> 1.2.1'
gem 'dm-is-searchable', '~> 1.2.0'
gem 'dm-is-tree',       '~> 1.2.0'
gem 'dm-migrations',    '~> 1.2.0'
gem 'dm-pager',         git: 'https://github.com/lokka/dm-pagination'
gem 'dm-tags',          '~> 1.2.0'
gem 'dm-timestamps',    '~> 1.2.0'
gem 'dm-types',         '~> 1.2.2'
gem 'dm-validations',   '~> 1.2.0'
gem 'erubis', '~> 2.7.0'
gem 'haml', '~> 5.0'
gem 'i18n', '~> 0.7'
gem 'kramdown'
gem 'mimemagic'
gem 'nokogiri'
gem 'padrino-helpers', '~> 0.14.1.1'
gem 'rack'
gem 'rack-flash', '~> 0.1.2'
gem 'rake', '~> 11.0'
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
gem 'wikicloth', '0.8.3'
gem 'yard-sinatra', '1.0.0'

Dir['public/plugin/lokka-*/Gemfile'].each {|path| load(path) }

group :production do
end

group :development, :test do
  gem 'tapp', '1.3.0'
end

group :development do
  gem 'dm-sqlite-adapter', '1.2.0'
  gem 'haml-lint'
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner', '0.7.1'
  gem 'dm-transactions', '~> 1.2.0'
  gem 'factory_girl', '~> 4.0'
  gem 'rack-test', '0.6.1', require: 'rack/test'
  gem 'rspec', '2.14.1'
  gem 'simplecov', require: false
end

group :mysql do
  gem 'dm-mysql-adapter', '1.2.0'
end

group :postgresql do
  gem 'dm-postgres-adapter', '1.2.0'
end
