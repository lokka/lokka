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

  context "access tag archive page" do
    before do
      post = Post.get(1)
      post.tag_list = 'lokka'
      post.save
    end

    it "should show lokka tag archive" do
      get '/tags/lokka/'
      last_response.should be_ok
    end
  end
end
