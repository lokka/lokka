# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def fixture_path
  File.expand_path(File.dirname(__FILE__) + '/../fixtures')
end

shared_context 'in site' do
  before { Factory(:site) }
  after { Site.delete_all; User.delete_all }
end
