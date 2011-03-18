source :rubygems

gem 'bundler', '~> 1.0.7'
gem 'rack-flash', '0.1.1'
gem 'i18n', '0.4.1'
gem 'sinatra', '1.1.2'
gem 'sinatra-r18n', '0.4.9'
gem 'sinatra-content-for', '0.2'
gem 'dm-migrations',  '1.0.2'
gem 'dm-timestamps',  '1.0.2'
gem 'dm-validations', '1.0.2'
gem 'dm-types',       '1.0.2'
gem 'dm-is-tree',     '1.0.2'
gem 'dm-tags',        '1.0.2'
gem 'dm-pager', '1.1.0'
gem 'dm-is-searchable', '1.0.2'
gem 'builder', '3.0.0'
gem 'haml', '3.0.18'
gem 'slim'
gem 'rake', '0.8.7'
gem 'exceptional', '2.0.25'
gem 'erubis', '2.6.6'
gem 'activesupport', '3.0.0'
gem 'shotgun'

Dir["public/plugin/lokka-*/Gemfile"].each {|path| eval(open(path) {|f| f.read }) }

group :production do
  gem 'dm-postgres-adapter', '1.0.0'
end

group :development do
  gem 'dm-sqlite-adapter', '1.0.2'
end

group :test do
  gem 'dm-sqlite-adapter', '1.0.2'
  gem 'rack-test', '0.5.4', :require => 'rack/test'
  gem 'rspec', '~> 2.5'
end
