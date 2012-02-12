require File.dirname(__FILE__) + '/../spec_helper'

shared_context "admin login" do
  include_context 'in site'

  before do
    Factory(:user, :name => 'test')
    post '/admin/login', {:name => 'test', :password => 'test'}
    follow_redirect!
  end

  after { User.destroy }
end
