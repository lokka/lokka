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

  context '/admin/mobile_themes' do
    it 'should show index' do
      get '/admin/mobile_themes'
      expect(last_response).to be_ok
      expect(last_response.body).to match('jarvi_mobile')
    end
  end

  context 'PUT /admin/mobile_themes' do
    it 'should change the mobile theme' do
      put '/admin/mobile_themes', title: 'jarvi_mobile'
      expect(last_response).to be_redirect
      expect(Site.first.mobile_theme).to eq('jarvi_mobile')
    end
  end
end
