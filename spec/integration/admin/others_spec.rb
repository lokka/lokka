# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'access admin page' do
  include_context 'admin login'

  context '/admin/' do
    it 'should show index' do
      get '/admin/'
      expect(last_response).to be_ok
    end
  end

  context '/admin/plugins' do
    it 'should show index' do
      get '/admin/plugins'
      expect(last_response).to be_ok
    end
  end

  context '/admin/site/edit' do
    it 'should show form for site' do
      get '/admin/site/edit'
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'PUT /admin/site' do
    it 'should update site information' do
      put '/admin/site', site: { description: 'new' }
      expect(last_response).to be_redirect
      expect(Site.first.description).to eq('new')
    end
  end

  context '/admin/import' do
    it 'should show form for import' do
      get '/admin/import'
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end
end
