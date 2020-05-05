# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'App' do
  include_context 'in site'

  context 'access pages' do
    context '/' do
      subject do
        get '/'
        last_response.body
      end

      it { should match('Test Site') }

      context 'when posts exists' do
        before do
          create(:xmas_post, title: 'First Post')
          create(:newyear_post)
        end

        after { Post.delete_all }

        it 'entries should be sorted by created_at in descending' do
          subject.index(/First Post/).should be > subject.index(/Test Post/)
        end
      end

      context 'number of posts displayed' do
        before { 11.times { create(:post) } }
        after { Post.delete_all }

        let(:regexp) do
          %r{<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>}
        end

        it 'should displayed 10' do
          subject.scan(regexp).size.should eq(10)
        end

        context 'change the number displayed on 5' do
          before { Site.first.update_attributes(per_page: 5) }
          after { Site.first.update_attributes(per_page: 10) }

          it 'should displayed 5' do
            subject.scan(regexp).size.should eq(5)
          end
        end
      end
    end

    context '/:id' do
      before { @post = create(:post) }
      after { Post.delete_all }
      context 'GET' do
        subject do
          get "/#{@post.id}"
          last_response.body
        end

        it { should match('Test Site') }
      end

      context 'POST' do
        before { Comment.delete_all }

        let(:params) do
          {
            check: 'check',
            comment: {
              name: 'lokka tarou',
              homepage: 'http://www.example.com/',
              body: 'good entry!'
            }
          }
        end

        it 'should add a comment to an article' do
          post "/#{@post.id}", params
          Comment.should have(1).item
        end
      end
    end

    context '/tags/lokka/' do
      before { create(:tag, name: 'lokka') }
      after { Tag.delete_all }

      it 'should show tag index' do
        get '/tags/lokka/'
        last_response.body.should match('Test Site')
      end
    end

    context '/category/:id/' do
      before do
        @category = create(:category)
        @category_child = create(:category_child, parent_id: @category.id)
      end

      after do
        Category.delete_all
      end

      it 'should show category index' do
        get "/category/#{@category.id}/"
        last_response.body.should match('Test Site')
      end

      it 'should show child category index' do
        get "/category/#{@category.id}/#{@category_child.id}/"
        last_response.body.should match('Test Site')
      end
    end

    describe 'a draft post' do
      before do
        create(:draft_post_with_tag_and_category)
        @post = Post.unpublished.first
        @post.should_not be_nil # gauntlet
        @post.tag_list.should_not be_empty
        @tag_name = @post.tag_list.first
        @category_id = @post.category.id
      end

      after do
        Post.delete_all
        Category.delete_all
      end

      it 'index page should not show the post' do
        get '/'
        last_response.body.should_not match('Draft post')
      end

      it 'tags page should not show the post' do
        get "/tags/#{@tag_name}/"
        last_response.body.should_not match('Draft post')
      end

      it 'category page should not show the post' do
        get "/category/#{@category_id}/"
        last_response.body.should_not match('Draft post')
      end

      it 'search result should not show the post' do
        get '/search/?query=post'
        last_response.body.should_not match('Draft post')
      end
    end

    context 'with custom permalink' do
      before do
        @page = create(:page)
        create(:post_with_slug)
        create(:later_post_with_slug)
        Option.permalink_enabled = 'true'
        Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'
        Comment.delete_all
      end

      after do
        Entry.delete_all
      end

      it 'an entry can be accessed by custom permalink' do
        get '/2011/01/09/welcome-lokka'
        last_response.body.should match('Welcome to Lokka!')
        last_response.body.should_not match('mediawiki test')
        get '/2011/01/10/a-day-later'
        last_response.body.should match('1 day passed')
        last_response.body.should_not match('Welcome to Lokka!')
      end

      it 'should redirect to custom permalink when accessed with original permalink' do
        get '/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')

        Option.permalink_enabled = 'false'
        get '/welcome-lokka'
        last_response.should_not be_redirect
      end

      it 'should not redirect access to page' do
        get "/#{@page.id}"
        last_response.should_not be_redirect
      end

      it 'should redirect to 0 filled url when accessed to non-0 prepended url in day/month' do
        get '/2011/1/9/welcome-lokka'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end

      it 'should remove trailing / of url by redirection' do
        get '/2011/01/09/welcome-lokka/'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should match('/2011/01/09/welcome-lokka')
      end

      it 'should return status code 200 if entry found by custom permalink' do
        get '/2011/01/09/welcome-lokka'
        last_response.status.should eq(200)
      end

      it 'should return status code 404 if entry not found' do
        get '/2011/01/09/welcome-wordpress'
        last_response.status.should eq(404)
      end

      it 'should return status code 404 to path with wrong structure' do
        get '/obviously/not/existing/path'
        last_response.status.should eq(404)
      end

      it 'POST request should add a comment to an article' do
        params = {
          check: 'check',
          comment: {
            name: 'lokka tarou',
            homepage: 'http://www.example.com/',
            body: 'good entry!'
          }
        }
        post '/2011/01/09/welcome-lokka', params
        Comment.should have(1).item
      end
    end

    describe 'with continue reading' do
      before { create(:post_with_more) }
      after { Post.delete_all }

      describe 'in entries index' do
        it 'should hide texts after <!--more-->' do
          regexp = %r{<p>a<\/p>\n\n<a href="\/[^"]*">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
          get '/'
          last_response.body.should match(regexp)
        end
      end

      describe 'in entry page' do
        it 'should not hide after <!--more-->' do
          regexp = %r{<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
          get '/post-with-more'
          last_response.body.should_not match(regexp)
        end
      end
    end
  end

  describe 'Search' do
    before do
      create_list(:post, 3, body: 'Udon')
      create(:post, body: 'Ramen')
    end

    it 'Should show search result' do
      get '/search/?query=ramen'
      expect(last_response.body).to match('Ramen')
      expect(last_response.body).not_to match('Udon')
    end
  end

  context 'access tag archive page' do
    before do
      create(:tag, name: 'lokka')
      post = create(:post)
      post.tag_list << 'lokka'
      post.save
    end

    after do
      Post.delete_all
      Tag.delete_all
    end

    it 'should show lokka tag archive' do
      get '/tags/lokka'
      last_response.should be_ok
      last_response.body.should match(/Test Post/)
    end
  end

  context 'when theme has i18n dir' do
    before do
      Theme.any_instance.stub(:exist_i18n?).and_return(true)
      Theme.any_instance.stub(:i18n_dir).and_return(
        File.expand_path('.', 'public/theme/foo/i18n')
      )
    end

    it 'should be success' do
      get '/'
      last_response.status.should eq(200)
    end
  end

  context 'when theme has coffee scripted js' do
    before do
      @file = 'public/theme/jarvi/script.coffee'
      content = <<-COFFEE.strip_heredoc
        console.log "Hello, It's me!"
      COFFEE
      File.open(@file, 'w') do |f|
        f.write content
      end
    end

    let(:expectation) do
      "(function() {\n  console.log(\"Hello, It's me!\");\n\n}).call(this);\n"
    end

    after do
      File.unlink(@file)
    end

    it 'should return compiled javascript' do
      get '/theme/jarvi/script.js'
      last_response.body.should eq(expectation)
    end
  end
end
