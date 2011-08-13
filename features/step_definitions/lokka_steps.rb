Given /^Lokka already started$/ do
    require './init'
    Thread.new do
      Lokka::App.run! :port => 9646
    end
end

When /^I access (\w+):(\d+)$/ do |host,port|
    sleep 10
    require 'open-uri'
    @result = open("http://127.0.0.1:#{port}").read
end

Then /^I should see "([^"]*)"$/ do |message|
    @result.should match message
end

