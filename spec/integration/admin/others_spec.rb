# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'access admin page' do
  include_context 'admin login'

  context '/admin/' do
    it 'should show index' do
      get '/admin/'
      last_response.should be_ok
    end
  end

  context '/admin/plugins' do
    it 'should show index' do
      get '/admin/plugins'
      last_response.should be_ok
    end
  end

  context '/admin/site/edit' do
    it 'should show form for site' do
      get '/admin/site/edit'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'PUT /admin/site' do
    it 'should update site information' do
      put '/admin/site', site: { description: 'new' }
      last_response.should be_redirect
      Site.first.description.should eq('new')
    end
  end

  context '/admin/import' do
    it 'should show form for import' do
      get '/admin/import'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end
end
