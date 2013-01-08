# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/snippets' do
  include_context 'admin login'
  before { @snippet = Factory(:snippet) }
  after { Snippet.delete_all }

  context 'GET /admin/snippets' do
    it 'should show index' do
      get '/admin/snippets'
      last_response.should be_ok
    end
  end

  context 'GET /admin/snippets/new' do
    it 'should show form for new snippets' do
      get '/admin/snippets/new'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'POST /admin/snippets' do
    it 'should create a new snippet' do
      sample = attributes_for(:snippet, name: 'Created Snippet')
      post '/admin/snippets', snippet: sample
      last_response.should be_redirect
      Snippet.where(name: 'Created Snippet').first.should_not be_nil
    end
  end

  context 'GET /admin/snippets/:id/edit' do
    it 'should show form for edit snippets' do
      get "/admin/snippets/#{@snippet.id}/edit"
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'PUT /admin/snippets/:id' do
    it 'should update the snippet"s body ' do
      put "/admin/snippets/#{@snippet.id}", snippet: { body: 'updated' }
      last_response.should be_redirect
      Snippet.find(@snippet.id).body.should == 'updated'
    end
  end

  context 'DELETE /admin/snippets/:id' do
    it 'should delete the snippet' do
      delete "/admin/snippets/#{@snippet.id}"
      last_response.should be_redirect
      Snippet.where(id: @snippet.id).first.should be_nil
    end
  end

  context 'when the snippet does not exist' do
    before { Snippet.delete_all }

    context 'GET' do
      before { get '/admin/snippets/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/snippets/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/snippets/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
