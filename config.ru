require './init'

require 'rack/ssl'

session_secret = "development_only_secret"
if ENV['RACK_ENV'] == 'production'
  if ENV["SESSION_SECRET"].nil? || ENV["SESSION_SECRET"] == ""
    raise 'ENV["SESSION_SECRET"] is blank. Run `heroku config:set SESSION_SECRET=some_random_string`'
  end

  use Rack::SSL

  require "newrelic_rpm"
  NewRelic::Agent.after_fork(:force_reconnect => true)
  session_secret = ENV["SESSION_SECRET"]
end

use Rack::Session::Cookie,
  :expire_after => nil, # セッションクッキー＝ブラウザ閉じるまで有効
  :secret => session_secret
run Lokka::App
