# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe Lokka::Helpers do
  context 'truncate' do
    it 'should return truncated string' do
      truncate('foo', :length => 2).should eql('fo...')
      truncate('いろは', :length => 2).should eql('いろ...')
    end
  end
end
