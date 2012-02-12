# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  before { Factory(:site) }
  after { Site.destroy; User.destroy }
  context "access pages" do
    context '/' do
      subject { get '/'; last_response.body }
      it { should match('Test Site') }

      context 'when posts exists' do
        before do
          Factory(:xmas_post, :title => 'First Post')
          Factory(:newyear_post)
        end

        after { Post.destroy }

        it "entries should be sorted by created_at in descending" do
          subject.index(/First Post/).should be > subject.index(/Test Post \d+/)
        end
      end
    end

    context '/:id' do
      before do
        post = Factory(:post)
        get "/#{post.id}"
      end

      after { Post.destroy }
      subject { last_response.body }
      it { should match('Test Site') }
    end

    context '/tags/lokka/' do
      before { Factory(:tag, :name => 'lokka') }
      after { Tag.destroy }

      it "should show tag index" do
        get '/tags/lokka/'
        last_response.body.should match('Test Site')
      end
    end

    describe 'a draft post' do
      before do
        Factory(:draft_post_with_tag_and_category)
        @post =  Post.first(:draft => true)
        @post.should_not be_nil # gauntlet
        @post.tag_list.should_not be_empty
        @tag_name =  @post.tag_list.first
        @category_id =  @post.category.id
      end

      after { Post.destroy }

      it "the entry page should return 404" do
        get '/test-draft-post'
        last_response.status.should == 404
        get "/#{@post.id}"
        last_response.status.should == 404
      end

      it "index page should not show the post" do
        get '/'
        last_response.body.should_not match('Draft post')
      end

      it "tags page should not show the post" do
        get "/tags/#{@tag_name}/"
        last_response.body.should_not match('Draft post')
      end

      it "category page should not show the post" do
        get "/category/#{@category_id}/"
        last_response.body.should_not match('Draft post')
      end

      it "search result should not show the post" do
        get '/search/?query=post'
        last_response.body.should_not match('Draft post')
      end
    end

    context "with custom permalink" do
      before do
        @page = Factory(:page)
        Factory(:post_with_slug)
        Factory(:later_post_with_slug)
        Option.permalink_enabled = true
        Option.permalink_format = "/%year%/%monthnum%/%day%/%slug%"
      end

      after do
        Option.permalink_enabled = false
        Entry.destroy
      end

      it "an entry can be accessed by custom permalink" do
        get '/2011/01/09/welcome-lokka'
        last_response.body.should match('Welcome to Lokka!')
        last_response.body.should_not match('mediawiki test')
        get '/2011/01/10/a-day-later'
        last_response.body.should match('1 day passed')
        last_response.body.should_not match('Welcome to Lokka!')
      end

      it "should redirect to custom permalink when accessed with original permalink" do
        get '/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')

        Option.permalink_enabled = false
        get '/welcome-lokka'
        last_response.should_not be_redirect
      end

      it "should not redirect access to page" do
        get "/#{@page.id}"
        last_response.should_not be_redirect
      end

      it "should redirect to 0 filled url when accessed to non-0 prepended url in day/month" do
        get '/2011/1/9/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end

      it "should remove trailing / of url by redirection" do
        get '/2011/01/09/welcome-lokka/'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end

      it 'should return status code 200 if entry found by custom permalink' do
        get '/2011/01/09/welcome-lokka'
        last_response.status.should == 200
      end

      it 'should return status code 404 if entry not found' do
        get '/2011/01/09/welcome-wordpress'
        last_response.status.should == 404
      end
    end

    context "with continue reading" do
      before { Factory(:post_with_more) }
      after { Post.destroy }
      describe 'in entries index' do
        it "should hide texts after <!--more-->" do
          get '/'
          last_response.body.should match(/<p>a<\/p>\n\n<a href="\/[^"]*">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>/)
        end
      end

      describe 'in entry page' do
        it "should not hide after <!--more-->" do
          get '/post-with-more'
          last_response.body.should_not match(/<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>/)
        end
      end
    end
  end

  context "access tag archive page" do
    before do
      Factory(:tag, :name => 'lokka')
      post = Factory(:post)
      post.tag_list = 'lokka'
      post.save
    end

    after { Post.destroy; Tag.destroy }

    it "should show lokka tag archive" do
      get '/tags/lokka/'
      last_response.should be_ok
      last_response.body.should match(/Test Post \d+/)
    end
  end

  describe 'login' do
    before { Factory(:user, :name => 'test') }
    after { User.destroy }
    context 'when valid username and password' do
      it 'should redirect to /admin/' do
        post '/admin/login', {:name => 'test', :password => 'test'}
        last_response.should be_redirect
        follow_redirect!
        last_request.env['PATH_INFO'].should == '/admin/'
      end
    end

    context 'when invalid username' do
      it 'should not redirect' do
        post '/admin/login', {:name => 'wrong', :password => 'test'}
        last_response.should_not be_redirect
      end
    end

    context 'when invalid password' do
      it 'should not redirect' do
        post '/admin/login', {:name => 'test', :password => 'wrong'}
        last_response.should_not be_redirect
      end
    end

    context 'when invalid username and password' do
      it 'should not redirect' do
        post '/admin/login', {:name => 'wrong', :password => 'wrong'}
        last_response.should_not be_redirect
      end
    end

  end

  describe 'access admin page' do
    before do
      Factory(:user, :name => 'test')
      post '/admin/login', {:name => 'test', :password => 'test'}
      follow_redirect!
    end

    after { User.destroy }

    context '/admin/' do
      it "should show index" do
        get '/admin/'
        last_response.should be_ok
      end
    end

    context '/admin/posts' do
      before do
        @post = Factory(:post)
        Factory(:draft_post)
      end
      after { Post.destroy }

      context 'with no option' do
        it 'should show all posts' do
          get '/admin/posts'
          last_response.body.should match('Test Post')
          last_response.body.should match('Draft Post')
        end
      end

      context 'with draft option' do
        it 'should show only draft posts' do
          get '/admin/posts', {:draft => 'true'}
          last_response.body.should_not match('Test Post')
          last_response.body.should match('Draft Post')
        end
      end

      context '/admin/posts/new' do
        it 'should show edit page' do
          get '/admin/posts/new'
          last_response.body.should match('<form')
        end
      end

      context 'POST /admin/posts' do
        it 'should create a new post' do
          sample = Factory.attributes_for(:post, :slug => 'created_now')
          post '/admin/posts', { :post => sample }
          last_response.should be_redirect
          Post('created_now').should_not be_nil
        end
      end

      context '/admin/posts/:id/edit' do
        it 'should show edit page' do
          get "/admin/posts/#{@post.id}/edit"
          last_response.body.should match('<form')
          last_response.body.should match('Test Post')
        end
      end

      context 'PUT /admin/posts/:id' do
        it 'should update the post\'s body ' do
          put "/admin/posts/#{@post.id}", { :post => { :body => 'updated' } }
          last_response.should be_redirect
          Post(@post.id).body.should == 'updated'
        end
      end
    end

    context '/admin/pages' do
      before do
        @page = Factory(:page)
        Factory(:draft_page)
      end
      after { Page.destroy }

      context 'with no option' do
        it 'should show all pages' do
          get '/admin/pages'
          last_response.body.should match('Test Page')
          last_response.body.should match('Draft Page')
        end
      end

      context 'with draft option' do
        it 'should show only draft pages' do
          get '/admin/pages', {:draft => 'true'}
          last_response.body.should_not match('Test Page')
          last_response.body.should match('Draft Page')
        end
      end

      context '/admin/pages/new' do
        it 'should show edit page' do
          get '/admin/pages/new'
          last_response.body.should match('<form')
        end
      end

      context 'POST /admin/pages' do
        it 'should create a new page' do
          sample = Factory.attributes_for(:page, :slug => 'dekitate')
          post '/admin/pages', { :page => sample }
          last_response.should be_redirect
          Page('dekitate').should_not be_nil
        end
      end

      context '/admin/pages/:id/edit' do
        it 'should show edit page' do
          get "/admin/pages/#{@page.id}/edit"
          last_response.body.should match('<form')
          last_response.body.should match('Test Page')
        end
      end

      context 'PUT /admin/pages/:id' do
        it 'should update the page\'s body ' do
          put "/admin/pages/#{@page.id}", { :page => { :body => 'updated' } }
          last_response.should be_redirect
          Page(@page.id).body.should == 'updated'
        end
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
        last_response.body.should match('<form')
      end
    end

    context 'with a category' do
      before { @category = Factory(:category) }
      after { Category.destroy }

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
          last_response.body.should match('<form')
        end
      end

      context '/admin/categories/:id/edit' do
        it 'should show form for edit categories' do
          get "/admin/categories/#{@category.id}/edit"
          last_response.should be_ok
          last_response.body.should match('<form')
        end
      end
    end

    context '/admin/tags' do
      before { Factory(:tag) }
      after { Tag.destroy }

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
        last_response.body.should match('<form')
      end
    end

    context '/admin/users/:id/edit' do
      before { @user = User.first }
      it 'should show form for edit users' do
        get "/admin/users/#{@user.id}/edit"
        last_response.should be_ok
        last_response.body.should match('<form')
      end
    end

    context 'with a snippet' do
      before { @snippet = Factory(:snippet) }
      after { Snippet.destroy }

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
          last_response.body.should match('<form')
        end
      end

      context '/admin/snippets/:id/edit' do
        it 'should show form for edit snippets' do
          get "/admin/snippets/#{@snippet.id}/edit"
          last_response.should be_ok
          last_response.body.should match('<form')
        end
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
        get '/admin/site/edit'
        last_response.should be_ok
        last_response.body.should match('<form')
      end
    end

    context '/admin/import' do
      it 'should show form for import' do
        get '/admin/import'
        last_response.should be_ok
        last_response.body.should match('<form')
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

      it 'GET should show form for custom permalink' do
        get '/admin/permalink'
        last_response.should be_ok
        last_response.body.should match('<form')
      end

      it 'PUT should change Option' do
        put '/admin/permalink', :enable => '1', :format => '/%year%/%slug%'
        Option.permalink_format.should == "/%year%/%slug%"
        Option.permalink_enabled.should == "true"
      end

      it 'should show error when format including incomplete tag' do
        put '/admin/permalink', :enable => '1', :format => '/%year%/%slug'
        follow_redirect!
        last_response.body.should match('not closed')
        Option.permalink_format.should == "/%year%/%id%"
        Option.permalink_enabled.should == "false"
      end

      it "should show error when format doesn't include any tags" do
        put '/admin/permalink', :enable => '1', :format => '/'
        follow_redirect!
        last_response.body.should match('should include')
        Option.permalink_format.should == "/%year%/%id%"
        Option.permalink_enabled.should == "false"
      end
    end
  end
end
