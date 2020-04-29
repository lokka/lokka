# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def fixture_path
  File.expand_path(File.dirname(__FILE__) + '/../fixtures')
end

shared_context 'in site' do
  before do
    FactoryGirl.create(:site)
  end

  after do
    Site.delete_all
    User.delete_all
  end
end
