# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lokka/version"

Gem::Specification.new do |s|
  s.name        = "lokka"
  s.version     = Lokka::VERSION
  s.authors     = ["Masaki Komagata"]
  s.email       = ["komagata@gmail.com"]
  s.homepage    = "http://lokka.org/"
  s.summary     = %q{CMS for Cloud}
  s.description = %q{CMS for Cloud.}

  s.rubyforge_project = "lokka"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'rack-test', '0.6.0'
  s.add_runtime_dependency 'bundler', '~> 1.0.7'
  s.add_runtime_dependency 'rack', '1.3.4'
  s.add_runtime_dependency 'rack-flash', '0.1.1'
  s.add_runtime_dependency 'i18n', '0.5.0'
  s.add_runtime_dependency 'sinatra', '1.3.1'
  s.add_runtime_dependency 'sinatra-contrib', '1.3.1'
  s.add_runtime_dependency 'sinatra-r18n', '0.4.11'
  s.add_runtime_dependency 'sinatra-content-for', '0.2'
  s.add_runtime_dependency 'dm-core',          '1.2.0'
  s.add_runtime_dependency 'dm-migrations',    '1.2.0'
  s.add_runtime_dependency 'dm-timestamps',    '1.2.0'
  s.add_runtime_dependency 'dm-validations',   '1.2.0'
  s.add_runtime_dependency 'dm-types',         '1.2.0'
  s.add_runtime_dependency 'dm-is-tree',       '1.2.0'
  s.add_runtime_dependency 'dm-tags',          '1.2.0'
  s.add_runtime_dependency 'dm-is-searchable', '1.2.0'
  s.add_runtime_dependency 'dm-pager',         '1.1.0'
  s.add_runtime_dependency 'dm-aggregates',    '1.2.0'
  s.add_runtime_dependency 'data_objects', '0.10.7'
  s.add_runtime_dependency 'builder', '3.0.0'
  s.add_runtime_dependency 'haml', '3.1.1'
  s.add_runtime_dependency 'sass', '3.1.1'
  s.add_runtime_dependency 'slim', '0.9.2'
  s.add_runtime_dependency 'rake', '0.9.2'
  s.add_runtime_dependency 'erubis', '2.6.6'
  s.add_runtime_dependency 'activesupport', '3.1.1'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'dm-sqlite-adapter', '1.2.0.rc2'
end
