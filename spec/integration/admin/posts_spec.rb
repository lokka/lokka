require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/posts' do
  include_context 'admin login'

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

  context 'DELETE /admin/posts/:id' do
    it 'should delete the post' do
      delete "/admin/posts/#{@post.id}"
      last_response.should be_redirect
      Post(@post.id).should be_nil
    end
  end
end
