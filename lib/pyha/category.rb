class Category
  include DataMapper::Resource

  property :id, Serial
  property :parent_id, Integer
  property :name, String, :length => 255, :unique => true
  property :slug, Slug, :length => 255, :unique => true

  is :tree, :order => :name

  has n, :documents

  validates_uniqueness_of :name
  validates_uniqueness_of :slug

  def self.get_by_name_or_slug(str)
    if ret = first(:slug => str)
      ret
    else
      first(:name => str)
    end
  end

  def fuzzy_slug
    slug || name
  end

  def link
    cats = [fuzzy_slug]
    ancestors.each do |ancestor|
      cats.unshift ancestor.fuzzy_slug
    end
    "/category/#{cats.join('/')}/"
  end
end
