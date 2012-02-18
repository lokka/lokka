require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  context 'with slug' do
    subject { build :post_with_slug }

    its(:link) { should eq('/welcome-lokka') }

    context 'when permalink is enabled' do
      before do
        Option.permalink_format = "/%year%/%month%/%day%/%slug%"
        Option.permalink_enabled = true
      end

      its(:link) { should eq('/2011/01/09/welcome-lokka') }
    end

    context 'when parmalink_format is set but disabled' do
      before do
        Option.permalink_format = "/%year%/%month%/%day%/%slug%"
        Option.permalink_enabled = false
      end

      its(:link) { should eq('/welcome-lokka') }
    end
  end

  context "with id 1" do
    subject { build :post, :id => 1 }
    its(:edit_link) { should eq('/admin/posts/1/edit') }
  end

  context 'markup' do
    [:kramdown, :redcloth, :wikicloth].each do |markup|
      describe "a post using #{markup}" do
        let(:post) { Factory(markup) }
        it { post.body.should_not == post.raw_body }
        it { post.body.should match('<h1') }
      end
    end

    context 'default' do
      let(:post) { build :post }
      it { post.body.should == post.raw_body }
    end
  end

  context "previous or next" do
    let!(:before) { create :xmas_post }
    let!(:after)  { create :newyear_post }

    it "should return previous page instance" do
      after.prev.should == before
      after.prev.created_at.should < after.created_at
    end

    it "should return next page instance" do
      before.next.should == after
      before.next.created_at.should > before.created_at
    end

    describe "the latest article" do
      subject { after }
      its(:next) { should be_nil }
    end

    describe "the first article" do
      subject { before }
      its(:prev) { should be_nil }
    end
  end

  describe '.first' do
    before { build :post }
    it { expect { Post.first }.not_to raise_error }
  end
end
