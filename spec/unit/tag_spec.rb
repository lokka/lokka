require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Tag' do
  context "with name lokka" do
    let!(:tag) { create :tag, :name => 'lokka' }
    subject { tag }

    its(:link) { should == '/tags/lokka/' }

    it 'Tag(name) should return the instance' do
      Tag('lokka').should eql(tag)
    end
  end
end
