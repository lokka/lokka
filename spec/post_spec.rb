require File.dirname(__FILE__) + '/spec_helper'

describe Post do
  context '#link' do
    it "should return correct link path" do
      post = Post.get(1)
      post.link.should eq('/welcome-lokka')
    end

    it "returns custom permalink when custom permalink enabled" do
      Option.permalink_format = "/%year%/%month%/%day%/%slug%"
      Option.permalink_enabled = true
      post = Post.get(1)
      post.link.should eq('/2011/01/09/welcome-lokka')
      Option.permalink_enabled = false
      post = Post.get(1)
      post.link.should eq('/welcome-lokka')
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

  context "continue reading" do
    describe 'in entries page' do
      it "hide texts after <!--more-->" do
      end

      it "hide texts after first <!--more-->" do
      end
    end

    describe 'in entry page' do
      it "don't hide after <!--more-->" do
      end
    end
  end

  describe '.first' do
    it { lambda { Post.first }.should_not raise_error }
  end
end
