require File.dirname(__FILE__) + '/../helper'

class PostTest < Test::Unit::TestCase
  context "link" do
    should "return correct link path" do
      post = Post.get(1)
      assert_equal '/slug', post.link
    end
  end
  
  context "edit_link" do
    should "return correct link path" do
      post = Post.get(1)
      assert_equal '/admin/posts/1/edit', post.edit_link
    end
  end
end
