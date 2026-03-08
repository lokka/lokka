# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'lokka'
  s.version = '1.0.0'
  s.required_ruby_version = '>= 3.3'

  s.authors = ['Masaki KOMAGATA', 'Teppei Machida']
  s.date = '2024-01-01'
  s.description = 'CMS written in Ruby for cloud computing.'
  s.email = 'komagata@gmail.com'
  s.executables = ['lokka']
  s.extra_rdoc_files = [
    'LICENSE',
    'README.ja.rdoc',
    'README.rdoc'
  ]
  s.homepage = 'https://github.com/lokka/lokka'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.summary = 'CMS for Cloud.'

  s.add_runtime_dependency 'activerecord', '~> 7.2'
  s.add_runtime_dependency 'activesupport', '~> 7.2'
  s.add_runtime_dependency 'builder'
  s.add_runtime_dependency 'haml', '~> 6.0'
  s.add_runtime_dependency 'i18n'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'rack-session'
  s.add_runtime_dependency 'rake', '~> 13.0'
  s.add_runtime_dependency 'sinatra', '~> 4.0'
  s.add_runtime_dependency 'sinatra-activerecord', '~> 2.0'
  s.add_runtime_dependency 'sinatra-contrib', '~> 4.0'
  s.add_runtime_dependency 'sinatra-flash', '~> 0.3.0'
  s.add_runtime_dependency 'tilt', '~> 2.0'

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'sqlite3', '~> 2.0'
end
