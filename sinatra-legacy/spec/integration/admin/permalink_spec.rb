# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/permalink' do
  include_context 'admin login'

  before do
    Option.permalink_enabled = false
    Option.permalink_format = '/%year%/%id%'
  end

  after do
    Option.permalink_enabled = false
  end

  it 'GET should show form for custom permalink' do
    get '/admin/permalink'
    last_response.should be_ok
    last_response.body.should match('<form')
  end

  it 'PUT should change Option' do
    put '/admin/permalink', enable: '1', format: '/%year%/%slug%'
    Option.permalink_format.should eq('/%year%/%slug%')
    Option.permalink_enabled.should eq('true')
  end

  it 'should show error when format including incomplete tag' do
    put '/admin/permalink', enable: '1', format: '/%year%/%slug'
    follow_redirect!
    last_response.body.should match('not closed')
    Option.permalink_format.should eq('/%year%/%id%')
    Option.permalink_enabled.should eq('false')
  end

  it "should show error when format doesn't include any tags" do
    put '/admin/permalink', enable: '1', format: '/'
    follow_redirect!
    last_response.body.should match('should include')
    Option.permalink_format.should eq('/%year%/%id%')
    Option.permalink_enabled.should eq('false')
  end
end
