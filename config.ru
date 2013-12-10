require './init'

require 'rack/ssl'
if ENV['RACK_ENV'] == 'production'
  use Rack::SSL
end

run Lokka::App
