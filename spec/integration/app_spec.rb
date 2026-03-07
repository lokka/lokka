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

        after { Post.destroy }

        it 'entries should be sorted by created_at in descending' do
          subject.index(/First expect(Post/)).to be > subject.index(/Test Post \d+/)
        end
      end

      context 'number of posts displayed' do
        before { 11.times { create(:post) } }
        after { Post.destroy }

        let(:regexp) do
          %r{<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>}
        end

        it 'should displayed 10' do
          expect(subject.scan(regexp).size).to eq(10)
        end

        context 'change the number displayed on 5' do
          before { Site.first.update(per_page: 5) }
          after { Site.first.update(per_page: 10) }

          it 'should displayed 5' do
            expect(subject.scan(regexp).size).to eq(5)
          end
        end
      end
    end

    context '/:id' do
      before { @post = create(:post) }
      after { Post.destroy }
      context 'GET' do
        subject do
          get "/#{@post.id}"
          last_response.body
        end

        it { should match('Test Site') }
      end

      context 'POST' do
        before { Comment.destroy }

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
          expect(Comment).to have(1).item
        end
      end
    end

    context '/tags/lokka/' do
      before { create(:tag, name: 'lokka') }
      after { Tag.destroy }

      it 'should show tag index' do
        get '/tags/lokka/'
        expect(last_response.body).to match('Test Site')
      end
    end

    context '/category/:id/' do
      before do
        @category = create(:category)
        @category_child = create(:category_child, parent: @category)
      end

      after do
        Category.destroy
      end

      it 'should show category index' do
        get "/category/#{@category.id}/"
        expect(last_response.body).to match('Test Site')
      end

      it 'should show child category index' do
        get "/category/#{@category.id}/#{@category_child.id}/"
        expect(last_response.body).to match('Test Site')
      end
    end

    describe 'a draft post' do
      before do
        create(:draft_post_with_tag_and_category)
        @post = Post.first(draft: true)
        expect(@post).not_to be_nil # gauntlet
        expect(@post.tag_list).not_to be_empty
        @tag_name = @post.tag_list.first
        @category_id = @post.category.id
      end

      after do
        Post.destroy
        Category.destroy
      end

      it 'the entry page should return 404' do
        get '/test-draft-post'
        expect(last_response.status).to eq(404)
        get "/#{@post.id}"
        expect(last_response.status).to eq(404)
      end

      it 'index page should not show the post' do
        get '/'
        expect(last_response.body).not_to match('Draft post')
      end

      it 'tags page should not show the post' do
        get "/tags/#{@tag_name}/"
        expect(last_response.body).not_to match('Draft post')
      end

      it 'category page should not show the post' do
        get "/category/#{@category_id}/"
        expect(last_response.body).not_to match('Draft post')
      end

      it 'search result should not show the post' do
        get '/search/?query=post'
        expect(last_response.body).not_to match('Draft post')
      end
    end

    context 'with custom permalink' do
      before do
        @page = create(:page)
        create(:post_with_slug)
        create(:later_post_with_slug)
        Option.permalink_enabled = true
        Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'
        Comment.destroy
      end

      after do
        Option.permalink_enabled = false
        Entry.destroy
      end

      it 'an entry can be accessed by custom permalink' do
        get '/2011/01/09/welcome-lokka'
        expect(last_response.body).to match('Welcome to Lokka!')
        expect(last_response.body).not_to match('mediawiki test')
        get '/2011/01/10/a-day-later'
        expect(last_response.body).to match('1 day passed')
        expect(last_response.body).not_to match('Welcome to Lokka!')
      end

      it 'should redirect to custom permalink when accessed with original permalink' do
        get '/welcome-lokka'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to match('/2011/01/09/welcome-lokka')
      end

      it do
        Option.permalink_enabled = false
        get '/welcome-lokka'
        expect(last_response).not_to be_redirect
      end

      it 'should not redirect access to page' do
        get "/#{@page.id}"
        expect(last_response).not_to be_redirect
      end

      it 'should redirect to 0 filled url when accessed to non-0 prepended url in day/month' do
        get '/2011/1/9/welcome-lokka'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to match('/2011/01/09/welcome-lokka')
      end

      it 'should remove trailing / of url by redirection' do
        get '/2011/01/09/welcome-lokka/'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to match('/2011/01/09/welcome-lokka')
      end

      it 'should return status code 200 if entry found by custom permalink' do
        get '/2011/01/09/welcome-lokka'
        expect(last_response.status).to eq(200)
      end

      it 'should return status code 404 if entry not found' do
        get '/2011/01/09/welcome-wordpress'
        expect(last_response.status).to eq(404)
      end

      it 'should return status code 404 to path with wrong structure' do
        get '/obviously/not/existing/path'
        expect(last_response.status).to eq(404)
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
        expect(Comment).to have(1).item
      end
    end

    context 'with continue reading' do
      before { create(:post_with_more) }
      after { Post.destroy }
      describe 'in entries index' do
        it 'should hide texts after <!--more-->' do
          regexp = %r{<p>a<\/p>\n\n<a href="\/[^"]*">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
          get '/'
          expect(last_response.body).to match(regexp)
        end
      end

      describe 'in entry page' do
        it 'should not hide after <!--more-->' do
          regexp = %r{<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
          get '/post-with-more'
          expect(last_response.body).not_to match(regexp)
        end
      end
    end
  end

  context 'access tag archive page' do
    before do
      create(:tag, name: 'lokka')
      post = create(:post)
      post.tag_list = 'lokka'
      post.save
    end

    after do
      Post.destroy
      Tag.destroy
    end

    it 'should show lokka tag archive' do
      get '/tags/lokka/'
      expect(last_response).to be_ok
      expect(last_response.body).to match(/Test Post \d+/)
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
      expect(last_response.status).to eq(200)
    end
  end

  context 'when theme has coffee scripted js' do
    before do
      @file = 'public/theme/jarvi/script.coffee'
      content = <<-COFFEE.strip_heredoc
      console.log "Hello, It's me!"
      COFFEE
      open(@file, 'w') do |f|
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
      expect(last_response.body).to eq(expectation)
    end
  end
end
