source :rubygems

gem 'bundler'
gem 'rack', '1.3.6'
gem 'rack-flash', '0.1.1'
gem 'i18n', '0.6.0'
gem 'sinatra', '1.3.2'
gem 'sinatra-contrib', '1.3.1'
gem 'dm-core',          '1.2.0'
gem 'dm-migrations',    '1.2.0'
gem 'dm-timestamps',    '1.2.0'
gem 'dm-validations',   '1.2.0'
gem 'dm-types',         '1.2.0'
gem 'dm-is-tree',       '1.2.0'
gem 'dm-tags',          '1.2.0'
gem 'dm-is-searchable', '1.2.0'
gem 'dm-pager',         :git => 'git://github.com/yayugu/dm-pagination.git'
gem 'dm-aggregates',    '1.2.0'
gem 'data_objects',     :git => 'git://github.com/datamapper/do.git', :ref => 'd7cb262d89a1'
gem 'builder', '3.0.0'
gem 'haml', '3.1.1'
gem 'sass', '3.1.1'
gem 'compass'
gem 'slim', '0.9.2'
gem 'rake', '~> 0.9.2'
gem 'erubis', '2.6.6'
gem 'activesupport', '3.1.1'
gem 'nokogiri', '1.5.2'
gem 'tux'
gem 'padrino-helpers', '0.10.5'
gem 'coderay', '1.0.5'
gem 'kramdown'
gem 'RedCloth', '4.2.9'
gem 'wikicloth', '0.7.1'
gem 'yard-sinatra', '1.0.0'
gem 'stringex', '1.3.2'
gem 'backports', '2.3.0'

Dir["public/plugin/lokka-*/Gemfile"].each {|path| eval(open(path) {|f| f.read }) }

group :production do
end

group :development do
  gem 'tapp', '1.3.0'
  gem 'dm-sqlite-adapter', '1.2.0'
end

group :test do
  gem 'tapp', '1.3.0'
  gem 'rack-test', '0.6.1', :require => 'rack/test'
  gem 'rspec', '2.8.0'
  gem 'simplecov', :require => false if RUBY_VERSION >= '1.9'
  gem 'factory_girl', '2.6.1'
  gem 'database_cleaner', '0.7.1'
end

group :mysql do
  gem 'dm-mysql-adapter', '1.2.0'
end

group :postgresql do
  gem 'dm-postgres-adapter', '1.2.0'
end

group :sqlite do
end
