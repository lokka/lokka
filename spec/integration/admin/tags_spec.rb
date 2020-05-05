# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/tags' do
  include_context 'admin login'
  before { @tag = create(:tag) }
  after { Tag.delete_all }

  context 'GET /admin/tags' do
    it 'should show index' do
      get '/admin/tags'
      last_response.should be_ok
    end
  end

  context 'GET /admin/tags/:id/edit' do
    it 'should show form' do
      get "/admin/tags/#{@tag.id}/edit"
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'PUT /admin/tags/:id' do
    it 'should change the name' do
      put "/admin/tags/#{@tag.id}", tag: { name: 'changed' }
      last_response.should be_redirect
      Tag.find(@tag.id).name.should == 'changed'
    end
  end

  context 'DELETE /admin/tags' do
    it 'should delete the tag' do
      delete "/admin/tags/#{@tag.id}"
      last_response.should be_redirect
      Tag.where(id: @tag.id).first.should be_nil
    end
  end

  context 'when the tag does not exist' do
    before { Tag.delete_all }

    context 'GET' do
      before { get '/admin/tags/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/tags/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/tags/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
