require File.dirname(__FILE__) + '/spec_helper'

describe 'Tag' do
  context 'link' do
    it 'should return link path' do
      tag = Tag.first(:name => 'lokka')
      tag.link.should eq('/tags/lokka/')
    end
  end

  it 'should return a tag instance' do
    tag = Tag.first(:name => 'lokka')
    Tag('lokka').should eql(tag)
  end
end
