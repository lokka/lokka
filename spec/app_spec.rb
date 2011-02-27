require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  context "Access pages" do
    it "should show index" do
      get '/'
      last_response.body.should match('Test Site')
    end

    it "should individual" do
      get '/1'
      last_response.body.should match('Test Site')
    end
  end
end
