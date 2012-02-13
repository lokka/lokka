require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/tags' do
  include_context 'admin login'
  before { @tag = Factory(:tag) }
  after { Tag.destroy }

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
      put "/admin/tags/#{@tag.id}", { :tag => { :name => 'changed' } }
      last_response.should be_redirect
      Tag.get(@tag.id).name.should == 'changed'
    end
  end

  context 'DELETE /admin/tags' do
    it 'should delete the tag' do
      delete "/admin/tags/#{@tag.id}"
      last_response.should be_redirect
      Tag.get(@tag.id).should be_nil
    end
  end
end
