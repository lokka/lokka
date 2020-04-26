# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Login' do
  include_context 'in site'
  before { FactoyrGirl.create(:user, name: 'test') }
  after { User.delete_all }

  shared_examples_for 'login failed' do
    it 'should not redirect' do
      last_response.should_not be_redirect
    end

    it 'should render login screen again' do
      last_response.body.should match('<body class=\'admin_login\'>')
    end

    it 'should not render dashboard side bar' do
      last_response.body.should_not match('<div id="aside">')
    end
  end

  context 'when valid username and password' do
    it 'should redirect to /admin/' do
      post '/admin/login', { name: 'test', password: 'test' }
      last_response.should be_redirect
      follow_redirect!
      last_request.env['PATH_INFO'].should eq('/admin/')
    end
  end

  context 'when invalid username' do
    before { post '/admin/login', { name: 'wrong', password: 'test' } }
    it_behaves_like 'login failed'
  end

  context 'when invalid password' do
    before { post '/admin/login', { name: 'test', password: 'wrong' } }
    it_behaves_like 'login failed'
  end

  context 'when invalid username and password' do
    before { post '/admin/login', { name: 'wrong', password: 'wrong' } }
    it_behaves_like 'login failed'
  end
end
