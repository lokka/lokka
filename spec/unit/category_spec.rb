# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  subject { Category }

  context 'on creating a new category with blank slug' do
    before { create :category }
    it { should have(1).item }
  end

  context 'on creating 2 new categories with blank slug' do
    before { create_list :category, 2 }
    subject { Category }
    it { should have(2).item }
  end
end
