source :rubygems

gem 'bundler', '~> 1.0.7'
gem 'rack-flash', '0.1.1'
gem 'i18n', '0.5.0'
gem 'sinatra', '1.2.3'
gem 'sinatra-r18n', '0.4.9'
gem 'sinatra-content-for', '0.2'
gem 'dm-core',        :git => 'git://github.com/datamapper/dm-core.git'
gem 'dm-migrations',  :git => 'git://github.com/datamapper/dm-migrations.git'
gem 'dm-timestamps',  :git => 'git://github.com/datamapper/dm-timestamps.git'
gem 'dm-validations', :git => 'git://github.com/datamapper/dm-validations.git'
gem 'dm-types',       :git => 'git://github.com/datamapper/dm-types.git'
gem 'dm-is-tree',     :git => 'git://github.com/datamapper/dm-is-tree.git'
gem 'dm-tags',        :git => 'git://github.com/komagata/dm-tags.git'
gem 'dm-pager',       :git => 'git://github.com/visionmedia/dm-pagination.git'
gem 'dm-is-searchable', :git => 'git://github.com/datamapper/dm-is-searchable.git'
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
  gem 'dm-postgres-adapter', '1.1.0'
  gem 'dm-mysql-adapter', '1.1.0'
end

group :development, :test do
  gem 'dm-sqlite-adapter', '1.1.0'
end

group :test do
  gem 'rack-test', '0.6.0', :require => 'rack/test'
  gem 'rspec', '~> 2.5'
end
