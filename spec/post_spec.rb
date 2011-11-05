# encoding: utf-8
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

  context 'markup' do
    it 'kramdown' do
      post = Post.get(6)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end

    it 'redcloth' do
      post = Post.get(7)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end
    
    it 'wikicloth' do
      post = Post.get(8)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end

    it 'default' do
      post = Post.get(1)
      post.body.should == post.raw_body
    end
  end
end
