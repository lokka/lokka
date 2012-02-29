require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_context "admin login" do
  include_context 'in site'

  before do
    Factory(:user, :name => 'test')
    post '/admin/login', {:name => 'test', :password => 'test'}
    follow_redirect!
  end

  after { User.destroy }
end

shared_examples_for 'a not found page' do
  it 'should return 404' do
    last_response.status.should == 404
  end
end
