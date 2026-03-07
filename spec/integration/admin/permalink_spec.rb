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
    expect(last_response).to be_ok
    expect(last_response.body).to match('<form')
  end

  it 'PUT should change Option' do
    put '/admin/permalink', enable: '1', format: '/%year%/%slug%'
    expect(Option.permalink_format).to eq('/%year%/%slug%')
    expect(Option.permalink_enabled).to eq('true')
  end

  it 'should show error when format including incomplete tag' do
    put '/admin/permalink', enable: '1', format: '/%year%/%slug'
    follow_redirect!
    expect(last_response.body).to match('not closed')
    expect(Option.permalink_format).to eq('/%year%/%id%')
    expect(Option.permalink_enabled).to eq('false')
  end

  it "should show error when format doesn't include any tags" do
    put '/admin/permalink', enable: '1', format: '/'
    follow_redirect!
    expect(last_response.body).to match('should include')
    expect(Option.permalink_format).to eq('/%year%/%id%')
    expect(Option.permalink_enabled).to eq('false')
  end
end
