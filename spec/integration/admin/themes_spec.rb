# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'themes' do
  include_context 'admin login'

  context '/admin/themes' do
    it 'should show index' do
      get '/admin/themes'
      expect(last_response).to be_ok
      expect(last_response.body).to match('curvy')
    end
  end

  context 'PUT /admin/themes' do
    it 'should change the theme' do
      put '/admin/themes', title: 'curvy'
      expect(last_response).to be_redirect
      expect(Site.first.theme).to eq('curvy')
    end
  end
end
