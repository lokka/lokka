#require 'spec/expectations'
require 'webrat'
require './init'
Webrat.configure do |config|
    config.mode = :sinatra
end

World do
  Thread.new {Lokka::App.run! :port => 9646}
end
