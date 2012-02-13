require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  after do
    Category.destroy
  end

  context "on creating a new category with blank slug" do
    before do
      Category.new({"title"=>"foo", "description"=>"bar", "slug"=>""}).save
    end
    subject { Category }
    it { should have(1).item }
  end

  context "on creating 2 new categories with blank slug" do
    before do
      Category.new({"title"=>"foo", "description"=>"bar", "slug"=>""}).save
      Category.new({"title"=>"bar", "description"=>"buz", "slug"=>""}).save
    end
    subject { Category }
    it { should have(2).item }
  end
end
