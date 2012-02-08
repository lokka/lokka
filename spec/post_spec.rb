require File.dirname(__FILE__) + '/spec_helper'

describe Post do
  after do
    Post.destroy
    User.destroy # User is generated for association
  end

  context '#link' do
    before do
      @post = Factory(:post_with_slug)
    end

    it "should return correct link path" do
      @post.link.should eq('/welcome-lokka')
    end

    it "returns custom permalink when custom permalink enabled" do
      Option.permalink_format = "/%year%/%month%/%day%/%slug%"
      Option.permalink_enabled = true
      @post.link.should eq('/2011/01/09/welcome-lokka')
      Option.permalink_enabled = false
      @post.link.should eq('/welcome-lokka')
    end
  end

  context "edit_link" do
    it "should return correct link path" do
      post = Factory(:post, :id => 1)
      post.edit_link.should eq('/admin/posts/1/edit')
    end
  end

  context 'markup' do
    it 'kramdown' do
      post = Factory(:kramdown)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end

    it 'redcloth' do
      post = Factory(:redcloth)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end

    it 'wikicloth' do
      post = Factory(:wikicloth)
      post.body.should_not == post.raw_body
      post.body.should match('<h1')
    end

    it 'default' do
      post = Factory(:post)
      post.body.should == post.raw_body
    end
  end

  context "previous or next" do
    before do
      xmas = Time.new(2011, 12, 25, 19, 0, 0)
      newyear = Time.new(2012, 1, 1, 0, 0, 0)
      @before = Factory(:post, :created_at => xmas, :updated_at => xmas)
      @after = Factory(:post, :created_at => newyear, :updated_at => newyear)
    end

    it "should return previous page instance" do
      @after.prev.should == @before
      @after.prev.created_at.should < @after.created_at
    end

    it "should return next page instance" do
      @before.next.should == @after
      @before.next.created_at.should > @before.created_at
    end

    describe "the latest article" do
      subject { @after }
      its(:next) { should be_nil }
    end

    describe "the first article" do
      subject { @before }
      its(:prev) { should be_nil }
    end
  end

  describe '.first' do
    before { Factory(:post) }
    it { lambda { Post.first }.should_not raise_error }
  end
end
