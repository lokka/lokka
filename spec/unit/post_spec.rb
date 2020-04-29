# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  context 'with slug' do
    subject { create :post_with_slug }

    its(:link) { should eq('/welcome-lokka') }

    context 'when permalink is enabled' do
      before do
        Option.permalink_format = '/%year%/%month%/%day%/%slug%'
        Option.permalink_enabled = true
      end

      its(:link) { should eq('/2011/01/09/welcome-lokka') }
    end

    context 'when parmalink_format is set but disabled' do
      before do
        Option.permalink_format = '/%year%/%month%/%day%/%slug%'
        Option.permalink_enabled = false
      end

      its(:link) { should eq('/welcome-lokka') }
    end

    context 'when a valid slug is specified' do
      subject { build :post, slug: 'valid_Str-ing1' }
      it { should be_valid }
    end

    context 'when an invalid slug is specified' do
      subject { build :post, slug: 'invalid string' }
      it 'should be invalid or created with a different name' do
        (!subject.valid? || subject.slug != 'invalid string').should be_true
      end
    end
  end

  context 'with id 1' do
    subject { build :post, id: 1 }
    its(:edit_link) { should eq('/admin/posts/1/edit') }
  end

  context 'markup' do
    %i[kramdown redcloth].each do |markup|
      describe "a post using #{markup}" do
        let(:post) { FactoryGirl.create(:post, markup) }
        it { post.body.should_not == post.raw_body }
        it { post.long_body.should match('<h1') }
      end
    end

    context 'default' do
      let(:post) { build :post }
      it { post.body.should == post.long_body }
    end
  end

  context 'previous or next' do
    let!(:before) { create :xmas_post }
    let!(:after)  { create :newyear_post }

    it 'should return previous page instance' do
      after.prev.should eq(before)
      after.prev.created_at.should < after.created_at
    end

    it 'should return next page instance' do
      before.next.should eq(after)
      before.next.created_at.should > before.created_at
    end

    describe 'the latest article' do
      subject { after }
      its(:next) { should be_nil }
    end

    describe 'the first article' do
      subject { before }
      its(:prev) { should be_nil }
    end
  end

  describe '.first' do
    before { build :post }
    it { expect { Post.first }.not_to raise_error }
  end

  describe '#tag_collection=' do
    let(:entry) { create(:entry) }
    before { entry.tag_collection = 'foo,bar' }
    it 'should update tags' do
      expect { entry.save }.to change { entry.tags }
    end
  end

  describe '#description' do
    %i[kramdown redcloth].each do |markup|
      describe 'should use converted markup.' do
        let(:post) { create(markup) }
        it { post.description.should eq("#{markup} test") }
      end
    end

    context 'should use the first paragraph.' do
      let(:post) { build :post }
      it { post.description.should eq('Welcome to Lokka!') }
    end

    describe 'body does not have <p> tag.' do
      let(:post) { build :post, body: '<h1>Hi!</h1>' }
      it { post.description.should eq('Hi! ') }
    end
  end
end
