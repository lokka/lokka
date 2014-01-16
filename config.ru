require './init'

require 'rack/ssl'
if ENV['RACK_ENV'] == 'production'
  use Rack::SSL

  require "newrelic_rpm"
  NewRelic::Agent.after_fork(:force_reconnect => true)
end

run Lokka::App
