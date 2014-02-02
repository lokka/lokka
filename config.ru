require './init'

require 'rack/ssl'
if ENV['RACK_ENV'] == 'production'
  use Rack::SSL

  require "newrelic_rpm"
  NewRelic::Agent.after_fork(:force_reconnect => true)
end

use Rack::Session::Cookie,
  :expire_after => 60 * 60 * 24 * 12,
  :secret => SecureRandom.hex(30)
run Lokka::App
