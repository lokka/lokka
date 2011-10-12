require File.dirname(__FILE__) + '/spec_helper'

describe 'Tag' do
  context 'link' do
    it 'should return link path' do
      tag = Tag.first(:name => 'lokka')
      tag.link.should eq('/tag/lokka/')
    end
  end
end
