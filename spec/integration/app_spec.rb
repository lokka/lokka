require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "App" do
  include_context 'in site'

  context "access pages" do
    context '/' do
      subject { get '/'; last_response.body }
      it { should match('Test Site') }

      context 'when posts exists' do
        before do
          Factory(:xmas_post, :title => 'First Post')
          Factory(:newyear_post)
        end

        after { Post.delete_all }

        it "entries should be sorted by created_at in descending" do
          subject.index(/First Post/).should be > subject.index(/Test Post/)
        end
      end

      context 'number of posts displayed' do
        before { 11.times { Factory(:post) } }
        after { Post.delete_all }

        it 'should displayed 10' do
          subject.scan(/<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>/).size.should eq(10)
        end

        context 'change the number displayed on 5' do
          before { Site.first.update_attributes(per_page: 5) }
          after { Site.first.update_attributes(per_page: 10) }

          it 'should displayed 5' do
            subject.scan(/<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>/).size.should eq(5)
          end
        end
      end
    end

    context '/:id' do
      before { @post = Factory(:post) }
      after { Post.delete_all }
      context "GET" do
        subject { get "/#{@post.id}"; last_response.body }
        it { should match('Test Site') }
      end

      context "POST" do
        before { Comment.delete_all }

        it "should add a comment to an article" do
          post "/#{@post.id}", { :check => "check", :comment => { :name => 'lokka tarou', :homepage => 'http://www.example.com/', :body => 'good entry!' } }
          Comment.should have(1).item
        end
      end
    end

    context '/tags/lokka/' do
      before { Factory(:tag, :name => 'lokka') }
      after { Tag.delete_all }

      it "should show tag index" do
        get '/tags/lokka/'
        last_response.body.should match('Test Site')
      end
    end

    context '/category/:id/' do
      before do
        @category = Factory(:category)
        @category_child = Factory(:category_child, :parent_id => @category.id)
      end

      after do
        Category.delete_all
      end

      it "should show category index" do
        get "/category/#{@category.id}/"
        last_response.body.should match('Test Site')
      end

      it "should show child category index" do
        get "/category/#{@category.id}/#{@category_child.id}/"
        last_response.body.should match('Test Site')
      end
    end

    describe 'a draft post' do
      before do
        FactoryGirl.create(:draft_post_with_tag_and_category)
        @post =  Post.unpublished.first
        @post.should_not be_nil # gauntlet
        @post.tag_list.should_not be_empty
        @tag_name =  @post.tag_list.first
        @category_id =  @post.category.id
      end

      after do
        Post.delete_all
        Category.delete_all
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
        Comment.delete_all
      end

      after do
        Entry.delete_all
      end

      it "should not redirect access to page" do
        get "/#{@page.id}"
        last_response.should_not be_redirect
      end

      it 'should return status code 404 to path with wrong structure' do
        get '/obviously/not/existing/path'
        last_response.status.should == 404
      end
    end
  end

  context "access tag archive page" do
    before do
      Factory(:tag, :name => 'lokka')
      post = Factory(:post)
      post.tag_list << 'lokka'
      post.save
    end

    after { Post.delete_all; Tag.delete_all }

    it "should show lokka tag archive" do
      get '/tags/lokka'
      last_response.should be_ok
      last_response.body.should match(/Test Post/)
    end
  end

  context "when theme has i18n dir" do
    before do
      Theme.any_instance.stub(:exist_i18n?).and_return(true)
      Theme.any_instance.stub(:i18n_dir).and_return(
        File.expand_path(".", "public/theme/foo/i18n")
      )
    end

    it "should be success" do
      get '/'
      last_response.status.should == 200
    end
  end
end
