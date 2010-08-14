class Post
  include DataMapper::Resource

  property :id, Serial
  property :slug, Slug, :length => 255, :unique => true
  property :title, String, :length => 255
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user
  belongs_to :category

  default_scope(:default).update(:order => [:created_at.desc])

  validates_uniqueness_of :slug

  def self.get_by_fuzzy_slug(str)
    if ret = first(:slug => str)
      ret
    else
      first(:id => str)
    end
  end

  def fuzzy_slug
    slug || id
  end

  def link
    "/#{fuzzy_slug}"
  end
end
