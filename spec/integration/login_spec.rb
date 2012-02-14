require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Login' do
  include_context 'in site'
  before { Factory(:user, :name => 'test') }
  after { User.destroy }
  context 'when valid username and password' do
    it 'should redirect to /admin/' do
      post '/admin/login', {:name => 'test', :password => 'test'}
      last_response.should be_redirect
      follow_redirect!
      last_request.env['PATH_INFO'].should == '/admin/'
    end
  end

  context 'when invalid username' do
    it 'should not redirect' do
      post '/admin/login', {:name => 'wrong', :password => 'test'}
      last_response.should_not be_redirect
    end
  end

  context 'when invalid password' do
    it 'should not redirect' do
      post '/admin/login', {:name => 'test', :password => 'wrong'}
      last_response.should_not be_redirect
    end
  end

  context 'when invalid username and password' do
    it 'should not redirect' do
      post '/admin/login', {:name => 'wrong', :password => 'wrong'}
      last_response.should_not be_redirect
    end
  end
end
