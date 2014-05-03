lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lokka/version'

Gem::Specification.new do |spec|
  spec.name          = 'lokka'
  spec.version       = Lokka::VERSION
  spec.authors       = ['Masaki Komagata']
  spec.email         = ['komagata@gmail.com']
  spec.summary       = 'CMS for Cloud.'
  spec.description   = 'CMS for Cloud.'
  spec.homepage      = 'http://lokka.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra', '~> 1.4.5'
  spec.add_runtime_dependency 'sinatra-contrib', '~> 1.4.2'
  spec.add_runtime_dependency 'activerecord', '~> 4.1.0'
  spec.add_runtime_dependency 'thin'
  spec.add_runtime_dependency 'slim'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
