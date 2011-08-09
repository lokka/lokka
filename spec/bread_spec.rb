# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe Bread do
  context "create with 2 args" do
    let(:bread) { Bread.new('foo','bar') }
    subject { bread }
    its(:name) { should == 'foo' }
    its(:link) { should == 'bar' }
    its(:last) { should_not be_true }
    its(:last?) { should_not be_true }
  end
  context "create with false as 3rd arg" do
    let(:bread) { Bread.new('foo','bar',false) }
    subject { bread }
    its(:name) { should == 'foo' }
    its(:link) { should == 'bar' }
    its(:last) { should_not be_true }
    its(:last?) { should_not be_true }
  end
  context "create with true as 3rd arg" do
    let(:bread) { Bread.new('foo','bar',true) }
    subject { bread }
    its(:name) { should == 'foo' }
    its(:link) { should == 'bar' }
    its(:last) { should be_true }
    its(:last?) { should be_true }
  end
end


