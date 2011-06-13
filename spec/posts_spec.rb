require File.dirname(__FILE__) + '/spec_helper'

describe "Posts" do
  context "link" do
    it "should return correct link path" do
      post = Post.get(1)
      post.link.should eq('/1')
    end
  end

  context "edit_link" do
    it "should return correct link path" do
      post = Post.get(1)
      post.edit_link.should eq('/admin/posts/1/edit')
    end
  end
end
