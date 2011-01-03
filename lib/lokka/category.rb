class Category
  include DataMapper::Resource

  property :id, Serial
  property :slug, Slug, :length => 255, :unique => true
  property :title, String, :length => 255, :unique => true
  property :description, Text
  property :type, Discriminator
  property :created_at, DateTime
  property :updated_at, DateTime
  property :parent_id, Integer

  is :tree, :order => :title

  has n, :entries

  def self.get_by_fuzzy_slug(str)
    ret = first(:slug => str)
    ret.blank? ? get(str) : ret
  end

  def fuzzy_slug
    slug.blank? ? id : slug
  end

  def link
    cats = [fuzzy_slug]
    ancestors.each do |ancestor|
      cats.unshift ancestor.fuzzy_slug
    end
    "/category/#{cats.join('/')}/"
  end
end

def Category(id_or_slug)
  Category.get_by_fuzzy_slug(id_or_slug.to_s)
end
