# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def fixture_path
  File.expand_path(File.dirname(__FILE__) + '/../fixtures')
end

shared_context 'in site' do
  before do
    create(:site)
  end

  after do
    Site.destroy
    User.destroy
  end
end
