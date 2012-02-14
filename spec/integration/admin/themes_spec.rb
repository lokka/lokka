require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'themes' do
  include_context 'admin login'

  context '/admin/themes' do
    it 'should show index' do
      get '/admin/themes'
      last_response.should be_ok
      last_response.body.should match('curvy')
    end
  end

  context 'PUT /admin/themes' do
    it 'should change the theme' do
      put '/admin/themes', { :title => 'curvy' }
      last_response.should be_redirect
      Site.first.theme.should == 'curvy'
    end
  end

  context '/admin/mobile_themes' do
    it 'should show index' do
      get '/admin/mobile_themes'
      last_response.should be_ok
      last_response.body.should match('jarvi_mobile')
    end
  end

  context 'PUT /admin/mobile_themes' do
    it 'should change the mobile theme' do
      put '/admin/mobile_themes', { :title => 'jarvi_mobile' }
      last_response.should be_redirect
      Site.first.mobile_theme.should == 'jarvi_mobile'
    end
  end
end
