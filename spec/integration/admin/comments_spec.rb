require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/comments' do
  include_context 'admin login'

  before do
    @post = Factory(:post)
    @comment = Factory(:comment, :entry => @post)
    Factory(:spam_comment, :entry => @post)
  end

  after do
    Comment.delete_all
    Post.delete_all
  end

  context 'GET /admin/comments' do
    it 'should show index' do
      get '/admin/comments'
      last_response.should be_ok
    end
  end

  context 'GET /admin/comments/new' do
    it 'should show form for new comment' do
      get '/admin/comments/new'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'POST /admin/comments' do
    it 'should create a new comment' do
      Comment.delete_all
      sample = Factory.attributes_for(:comment, :entry_id => @post.id)
      post '/admin/comments', { :comment => sample }
      last_response.should be_redirect
      Post.find(@post.id).comments.should have(1).item
    end
  end

  context 'GET /admin/comments/:id/edit' do
    it 'should show edit comment' do
      get "/admin/comments/#{@comment.id}/edit"
      last_response.body.should match('<form')
      last_response.body.should match('Test Comment')
    end
  end

  context 'PUT /admin/comments/:id' do
    it 'should update the comment\'s body ' do
      put "/admin/comments/#{@comment.id}", { :comment => { :body => 'updated' } }
      last_response.should be_redirect
      Comment.find(@comment.id).body.should == 'updated'
    end
  end

  context 'DELETE /admin/comments/:id' do
    it 'should delete the comment' do
      delete "/admin/comments/#{@comment.id}"
      last_response.should be_redirect
      Comment.where(id: @comment.id).first.should be_nil
    end
  end

  context 'delete /admin/comments/spam' do
    it 'should delete spam comments' do
      delete "/admin/comments/spam"
      last_response.should be_redirect
      Comment.spam.size.should == 0
    end
  end

  context 'when the comment does not exist' do
    before { Comment.delete_all }

    context 'GET' do
      before { get '/admin/comments/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/comments/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/comments/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
