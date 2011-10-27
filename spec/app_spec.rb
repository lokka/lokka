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

    context '/admin/' do
      it "should show index" do
        get '/admin/'
        last_response.should be_ok
      end
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

    context '/admin/posts/new' do
      it 'show edit page' do
        get '/admin/posts/new'
        last_response.body.should match('<form')
      end
    end

    context '/admin/posts/:id/edit' do
      it 'show edit page' do
        get '/admin/posts/1/edit'
        last_response.body.should match('<form')
        last_response.body.should match('Test Post')
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

    context '/admin/pages/new' do
      it 'show edit page' do
        get '/admin/pages/new'
        last_response.body.should match('<form')
      end
    end

    context '/admin/pages/:id/edit' do
      it 'show edit page' do
        get '/admin/pages/4/edit'
        last_response.body.should match('<form')
        last_response.body.should match('Test Page')
      end
    end

    context '/admin/comments' do
      it 'should show index' do
        get '/admin/comments'
        last_response.should be_ok
      end
    end

    context '/admin/comments/new' do
      it 'should show form for new comment' do
        get '/admin/comments/new'
        last_response.should be_ok
      end
    end

    context '/admin/categories' do
      it 'should show index' do
        get '/admin/categories'
        last_response.should be_ok
      end
    end

    context '/admin/categories/new' do
      it 'should show form for new categories' do
        get '/admin/categories/new'
        last_response.should be_ok
      end
    end

    context '/admin/categories/:id/edit' do
      it 'should show form for edit categories' do
        get '/admin/categories/1/edit'
        last_response.should be_ok
      end
    end

    context '/admin/tags' do
      it 'should show index' do
        get '/admin/tags'
        last_response.should be_ok
      end
    end

    context '/admin/users' do
      it 'should show index' do
        get '/admin/users'
        last_response.should be_ok
      end
    end

    context '/admin/users/new' do
      it 'should show form for new users' do
        get '/admin/users/new'
        last_response.should be_ok
      end
    end

    context '/admin/users/:id/edit' do
      it 'should show form for edit users' do
        get '/admin/users/1/edit'
        last_response.should be_ok
      end
    end

    context '/admin/snippets' do
      it 'should show index' do
        get '/admin/snippets'
        last_response.should be_ok
      end
    end

    context '/admin/snippets/new' do
      it 'should show form for new snippets' do
        get '/admin/snippets/new'
        last_response.should be_ok
      end
    end

    context '/admin/snippets/:id/edit' do
      it 'should show form for edit snippets' do
        get '/admin/snippets/1/edit'
        last_response.should be_ok
      end
    end

    context '/admin/themes' do
      it 'should show index' do
        get '/admin/themes'
        last_response.should be_ok
      end
    end

    context '/admin/mobile_themes' do
      it 'should show index' do
        get '/admin/mobile_themes'
        last_response.should be_ok
      end
    end

    context '/admin/plugins' do
      it 'should show index' do
        get '/admin/plugins'
        last_response.should be_ok
      end
    end

    context '/admin/site/edit' do
      it 'should show form for site' do
        get '/admin/snippets/new'
        last_response.should be_ok
      end
    end

    context '/admin/import' do
      it 'should show form for import' do
        get '/admin/import'
        last_response.should be_ok
      end
    end
  end
end
