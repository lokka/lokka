# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
  let(:tag) { create :tag, name: 'lokka' }

  describe '#link' do
    it { expect(tag.link).to eq('/tags/lokka/') }
  end

  it 'Tag(name) should return the instance' do
    expect(Tag('lokka')).to eql(tag)
  end
end
