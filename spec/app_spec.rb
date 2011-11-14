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

    it "should tags index" do
      get '/tags/lokka/'
      last_response.body.should match('Test Site')
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

    context "with custom permalink" do
      before do
        Option.permalink_enabled = true
        Option.permalink_format = "/%year%/%monthnum%/%day%/%slug%"
      end

      after do
        Option.permalink_enabled = false
      end

      it "can access entry by custom permalink" do
        get '/2011/01/09/welcome-lokka'
        last_response.body.should match('Welcome to Lokka!')
        last_response.body.should_not match('mediawiki test')
        get '/2011/01/10/a-day-later'
        last_response.body.should match('1 day passed')
        last_response.body.should_not match('Welcome to Lokka!')
      end

      it "redirects to custom permalink when accessed with original permalink" do
        get '/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')

        get '/4'
        last_response.should_not be_redirect

        Option.permalink_enabled = false
        get '/welcome-lokka'
        last_response.should_not be_redirect
      end

      it "redirects 0 filled url twhen accessed to non-0 prepended url in day/month" do
        get '/2011/1/9/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end

      it "redirects last / removed url when accessed / ended url" do
        get '/2011/01/09/welcome-lokka/'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end
    end

    context "with continue reading" do
      describe 'in entries page' do
        it "hide texts after <!--more-->" do
          get '/'
          last_response.body.should match(/<p>a<\/p>\n\n<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>/)
        end
      end

      describe 'in entry page' do
        it "don't hide after <!--more-->" do
          get '/9'
          last_response.body.should_not match(/<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>/)
        end
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

    context '/admin/permalink' do
      before do
        Option.permalink_enabled = false
        Option.permalink_format = "/%year%/%id%"
      end

      after do
        Option.permalink_enabled = false
      end

      it 'shows form for custom permalink' do
        get '/admin/permalink'
        last_response.should be_ok
      end

      it 'changes Option' do
        put '/admin/permalink', :enable => '1', :format => '/%year%/%slug%'
        Option.permalink_format.should == "/%year%/%slug%"
        Option.permalink_enabled.should == "true"
      end

      it 'shows error when format including incomplete tag' do
        put '/admin/permalink', :enable => '1', :format => '/%year%/%slug'
        follow_redirect!
        last_response.body.should match('not closed')
        Option.permalink_format.should == "/%year%/%id%"
        Option.permalink_enabled.should == "false"
      end

      it "shows error when format doesn't include any tags" do
        put '/admin/permalink', :enable => '1', :format => '/'
        follow_redirect!
        last_response.body.should match('should include')
        Option.permalink_format.should == "/%year%/%id%"
        Option.permalink_enabled.should == "false"
      end
    end
  end
end
