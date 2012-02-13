require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Tag' do
  after do
    Tag.destroy
    Tagging.destroy
  end

  context "with name lokka" do
    before { @tag = Factory(:tag, :name => 'lokka') }
    subject { @tag }
    its(:link) { should == '/tags/lokka/' }
    it 'Tag(name) should return the instance' do
      Tag('lokka').should eql(@tag)
    end
  end
end
