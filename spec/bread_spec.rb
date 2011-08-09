require File.dirname(__FILE__) + '/spec_helper'

describe Bread do
  context "create with 2 args" do
    let(:bread) { Bread.new('foo','bar') }
    subject { bread }
    it "should be true" do
      subject.name.should == 'foo'
      subject.link.should == 'bar'
      subject.last.should == false
    end
  end
  context "create with false as 3rd arg" do
    let(:bread) { Bread.new('foo','bar',false) }
    subject { bread }
    it "should be true" do
      subject.name.should == 'foo'
      subject.link.should == 'bar'
      subject.last.should == false
    end
  end
  context "create with true as 3rd arg" do
    let(:bread) { Bread.new('foo','bar',true) }
    subject { bread }
    it "should be true" do
      subject.name.should == 'foo'
      subject.link.should == 'bar'
      subject.last.should == true
    end
  end
  context "#last?" do
    context "if obj created with true" do
      let(:bread) { Bread.new('foo','bar',true) }
      subject { bread.last? }
      it { should == true }
    end
    context "if obj created with false" do
      let(:bread) { Bread.new('foo','bar',false) }
      subject { bread.last? }
      it { should == false }
    end
  end
end


