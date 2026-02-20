# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  context 'on creating a new category with blank slug' do
    before { create :category }
    it { expect(Category.count).to eq(1) }
  end

  context 'on creating 2 new categories with blank slug' do
    before { create_list :category, 2 }
    it { expect(Category.count).to eq(2) }
  end
end
