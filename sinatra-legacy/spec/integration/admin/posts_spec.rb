# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/posts' do
  include_context 'admin login'

  before do
    @post = create(:post)
    create(:draft_post)
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
      get '/admin/posts', draft: 'true'
      last_response.body.should_not match('Test Post')
      last_response.body.should match('Draft Post')
    end
  end

  context '/admin/posts/new' do
    it 'should show edit page' do
      get '/admin/posts/new'
      last_response.body.should match('<form')
    end

    Markup.engine_list.map(&:first).each do |markup|
      context "when #{markup} is set a default markup" do
        before { Site.first.update(default_markup: markup) }
        after { Site.first.update(default_markup: nil) }

        it "should select #{markup}" do
          get '/admin/posts/new'
          last_response.body.should match(%(value="#{markup}" selected="selected">))
        end
      end
    end
  end

  context 'POST /admin/posts' do
    it 'should create a new post' do
      sample = attributes_for(:post, slug: 'created_now')
      post '/admin/posts', post: sample
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
    it 'should update the post"s body ' do
      put "/admin/posts/#{@post.id}", post: { body: 'updated' }
      last_response.should be_redirect
      Post(@post.id).body.should eq('updated')
    end
  end

  context 'DELETE /admin/posts/:id' do
    it 'should delete the post' do
      delete "/admin/posts/#{@post.id}"
      last_response.should be_redirect
      Post(@post.id).should be_nil
    end
  end

  context 'when the post does not exist' do
    before { Post.destroy }

    context 'GET' do
      before { get '/admin/posts/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/posts/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/posts/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
