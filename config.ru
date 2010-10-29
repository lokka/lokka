Encoding.default_external = 'utf-8' if defined?(Encoding) && Encoding.respond_to?('default_external')
require './init'
run Lokka::App
