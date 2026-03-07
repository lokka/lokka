# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Login' do
  include_context 'in site'
  before { create(:user, name: 'test') }
  after { User.destroy }

  shared_examples_for 'login failed' do
    it 'should not redirect' do
      expect(last_response).not_to be_redirect
    end

    it 'should render login screen again' do
      expect(last_response.body).to match('<body class="admin_login">')
    end

    it 'should not render dashboard side bar' do
      expect(last_response.body).not_to match('<div id="aside">')
    end
  end

  context 'when valid username and password' do
    it 'should redirect to /admin/' do
      post '/admin/login', name: 'test', password: 'test'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.env['PATH_INFO']).to eq('/admin/')
    end
  end

  context 'when invalid username' do
    before { post '/admin/login', name: 'wrong', password: 'test' }
    it_behaves_like 'login failed'
  end

  context 'when invalid password' do
    before { post '/admin/login', name: 'test', password: 'wrong' }
    it_behaves_like 'login failed'
  end

  context 'when invalid username and password' do
    before { post '/admin/login', name: 'wrong', password: 'wrong' }
    it_behaves_like 'login failed'
  end
end
