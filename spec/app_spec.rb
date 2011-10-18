# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  context "access pages" do
    it "should show index" do
      get '/'
      last_response.body.should match('Test Site')
    end

    it "should individual" do
      get '/1'
      last_response.body.should match('Test Site')
    end

    it "entries is sort by created_at in descending" do
      get '/'
      body = last_response.body
      (body.index(/Test Post2/) < body.index(/Test Post[^\d]/)).should be_true
    end

    context 'contain draft post' do
      it "entry page returns 404" do
        get '/test_draft_page'
        last_response.status.should == 404
        get '/2'
        last_response.status.should == 404
      end

      it "entries page does not show the post" do
        get '/'
        last_response.body.should_not match('Draft post')

        get '/tags/lokka/'
        last_response.body.should_not match('Draft post')

        get '/category/1/'
        last_response.body.should_not match('Draft post')

        get '/search/?query=post'
        last_response.body.should_not match('Draft post')
      end
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
