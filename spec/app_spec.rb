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

  describe 'login' do
    context 'when valid username and password' do
      it 'redirect /admin/' do
        post '/admin/login', {:name => 'test', :password => 'test'}
        last_response.should be_redirect
        follow_redirect!
        last_request.env['PATH_INFO'].should == '/admin/'
      end
    end

    context 'when invalid username and password' do
      it 'not redirect' do
        post '/admin/login', {:name => 'test', :password => 'wrong'}
        last_response.should_not be_redirect
      end
    end
  end

  describe 'access admin page' do
    before do
      post '/admin/login', {:name => 'test', :password => 'test'}
      follow_redirect!
    end

    context '/admin/posts' do
      context 'when no option' do
        it 'show all posts' do
          get '/admin/posts'
          last_response.body.should match('Test Post')
          last_response.body.should match('Draft Post')
        end
      end

      context 'when draft option' do
        it 'show only draft posts' do
          get '/admin/posts', {:draft => 'true'}
          last_response.body.should_not match('Test Post')
          last_response.body.should match('Draft Post')
        end
      end
    end

    context '/admin/pages' do
      context 'when no option' do
        it 'show all pages' do
          get '/admin/pages'
          last_response.body.should match('Test Page')
          last_response.body.should match('Draft Page')
        end
      end

      context 'when draft option' do
        it 'show only draft pages' do
          get '/admin/pages', {:draft => 'true'}
          last_response.body.should_not match('Test Page')
          last_response.body.should match('Draft Page')
        end
      end
    end
  end
end
