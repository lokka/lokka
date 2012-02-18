require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Snippet" do
  context 'with id 1' do
    subject { build :snippet, :id => 1 }
    its(:edit_link) { should eq('/admin/snippets/1/edit') }
  end
end
