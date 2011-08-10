# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe Lokka::Helpers do
  context 'truncate' do
    it 'should return truncated string' do
      truncate('foo', :length => 2).should eql('fo...')
      truncate('いろは', :length => 2).should eql('いろ...')
    end
  end
  context 'months' do
    before :all do
      Post.all.each {|p| p.delete! unless p.id == 1}
      Post.create!({:user_id => 1, :created_at => '2012-01-09T05:39:08+09:00'})
      Post.create!({:user_id => 1, :created_at => '2013-02-09T05:39:08+09:00'})
      Post.create!({:user_id => 1, :created_at => '2013-02-09T05:39:08+09:00'})
      Post.create!({:user_id => 1, :created_at => '2013-03-09T05:39:08+09:00'})
      Post.create!({:user_id => 1, :created_at => '2013-03-09T05:39:08+09:00'})
      Post.create!({:user_id => 1, :created_at => '2013-03-09T05:39:08+09:00'})
    end
    subject { months }
    it{ subject.should include Openstruct.new(:year => '2012', :month => '01', :count => 1) }
    it{ subject.should include Openstruct.new(:year => '2013', :month => '01', :count => 2) }
    it{ subject.should include Openstruct.new(:year => '2013', :month => '01', :count => 3) }
    after :all do
      Post.all.each {|p| p.delete! unless p.id == 1}
    end
  end
end
