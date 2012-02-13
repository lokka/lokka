require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_context 'in site' do
  before { Factory(:site) }
  after { Site.destroy; User.destroy }
end
