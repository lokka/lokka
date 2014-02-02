require './init'

require 'rack/ssl'
if ENV['RACK_ENV'] == 'production'
  use Rack::SSL

  require "newrelic_rpm"
  NewRelic::Agent.after_fork(:force_reconnect => true)
end

use Rack::Session::Cookie,
  :secret => SecureRandom.hex(30)
  :expire_after => nil, # セッションクッキー＝ブラウザ閉じるまで有効
run Lokka::App
