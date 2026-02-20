# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  context 'with slug' do
    let(:post) { build :post_with_slug }

    it 'has correct link' do
      expect(post.link).to eq('/welcome-lokka')
    end

    context 'when permalink is enabled' do
      before do
        Option.permalink_format = '/%year%/%month%/%day%/%slug%'
        Option.permalink_enabled = true
      end

      it { expect(post.link).to eq('/2011/01/09/welcome-lokka') }
    end

    context 'when parmalink_format is set but disabled' do
      before do
        Option.permalink_format = '/%year%/%month%/%day%/%slug%'
        Option.permalink_enabled = false
      end

      it { expect(post.link).to eq('/welcome-lokka') }
    end

    context 'when a valid slug is specified' do
      subject { build :post, slug: 'valid_Str-ing1' }
      it { is_expected.to be_valid }
    end

    context 'when an invalid slug is specified' do
      subject { build :post, slug: 'invalid string' }
      it 'should be invalid or created with a different name' do
        expect(!subject.valid? || subject.slug != 'invalid string').to be_truthy
      end
    end
  end

  context 'with id 1' do
    let(:post) { build :post, id: 1 }
    it { expect(post.edit_link).to eq('/admin/posts/1/edit') }
  end

  context 'markup' do
    [:kramdown, :redcloth].each do |markup|
      describe "a post using #{markup}" do
        let(:post) { create(markup) }
        let(:regexp) { %r{<h1.*>(<a name.+</a><span .+>)*hi!(</span>)*</h1>\s*<p>#{markup} test</p>} }
        it { expect(post.body).not_to eq(post.raw_body) }
        it { expect(post.body.tr("\n", '')).to match(regexp) }
      end
    end

    context 'default' do
      let(:post) { build :post }
      it { expect(post.body).to eq(post.raw_body) }
    end
  end

  context 'previous or next' do
    let!(:before_post) { create :xmas_post }
    let!(:after_post)  { create :newyear_post }

    it 'should return previous page instance' do
      expect(after_post.prev).to eq(before_post)
      expect(after_post.prev.created_at).to be < after_post.created_at
    end

    it 'should return next page instance' do
      expect(before_post.next).to eq(after_post)
      expect(before_post.next.created_at).to be > before_post.created_at
    end

    describe 'the latest article' do
      it { expect(after_post.next).to be_nil }
    end

    describe 'the first article' do
      it { expect(before_post.prev).to be_nil }
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
      describe "uses converted #{markup} markup" do
        let(:post) { create(markup) }
        it { expect(post.description).to eq("#{markup} test") }
      end
    end

    context 'uses the first paragraph' do
      let(:post) { build :post }
      it { expect(post.description).to eq('Welcome to Lokka!') }
    end

    describe 'body does not have <p> tag' do
      let(:post) { build :post, body: '<h1>Hi!</h1>' }
      it { expect(post.description).to eq('Hi! ') }
    end
  end
end
