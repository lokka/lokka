require File.dirname(__FILE__) + '/spec_helper'

describe Category do
  before(:all) do
    @original_entry_count = Category.all.count
  end

  context "on creating a new category with blank slug" do
    before do
      @cat = Category.new({"title"=>"foo", "description"=>"bar", "slug"=>""})
      @cat.save
    end
    after { @cat.destroy }

    subject { Category }
    it { should have(@original_entry_count + 1).item }
  end

  context "on creating 2 new categories with blank slug" do
    before do
      @cat1 = Category.new({"title"=>"foo", "description"=>"bar", "slug"=>""})
      @cat2 = Category.new({"title"=>"bar", "description"=>"buz", "slug"=>""})
      @cat1.save
      @cat2.save
    end

    after do
      @cat1.destroy
      @cat2.destroy
    end

    subject { Category }
    it { should have(@original_entry_count + 2).item }
  end
end
