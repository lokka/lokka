require File.dirname(__FILE__) + '/spec_helper'

describe "Snippet" do
  context "edit_link" do
    it "should return correct link path" do
      snippet = Snippet.get(1)
      snippet.edit_link.should eq('/admin/snippets/1/edit')
    end
  end
end
