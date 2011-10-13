source :rubygems

gem 'bundler', '~> 1.0.7'
gem 'rack', '1.3.4'
gem 'rack-flash', '0.1.1'
gem 'i18n', '0.5.0'
gem 'sinatra', '1.3.1'
gem 'sinatra-contrib', '1.3.1'
gem 'sinatra-r18n', '0.4.9'
gem 'sinatra-content-for', '0.2'
gem 'dm-core',          '1.2.0.rc2'
gem 'dm-migrations',    '1.2.0.rc2'
gem 'dm-timestamps',    '1.2.0.rc2'
gem 'dm-validations',   '1.2.0.rc2'
gem 'dm-types',         '1.2.0.rc2'
gem 'dm-is-tree',       '1.2.0.rc2'
gem 'dm-tags',          '1.2.0.rc2' 
gem 'dm-is-searchable', '1.2.0.rc2'
gem 'dm-pager',         :git => 'git://github.com/yayugu/dm-pagination.git'
gem 'dm-aggregates',    '1.2.0.rc2'
gem 'data_objects',     :git => 'git://github.com/datamapper/do.git', :ref => 'd7cb262d89a1'
gem 'builder', '3.0.0'
gem 'haml', '3.1.1'
gem 'sass', '3.1.1'
gem 'slim', '0.9.2'
gem 'rake', '0.8.7'
gem 'erubis', '2.6.6'
gem 'activesupport', '3.0.7'
gem 'nokogiri'
gem 'tux'

Dir["public/plugin/lokka-*/Gemfile"].each {|path| eval(open(path) {|f| f.read }) }

group :production do
  gem 'dm-postgres-adapter', '1.2.0.rc2'
  gem 'dm-mysql-adapter', '1.2.0.rc2'
end

group :development, :test do
  gem 'dm-sqlite-adapter', '1.2.0.rc2'
end

group :test do
  gem 'rack-test', '0.6.0', :require => 'rack/test'
  gem 'rspec', '~> 2.5'
  gem 'simplecov', :require => false if RUBY_VERSION >= '1.9'
end
