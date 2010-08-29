class Entry
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer
  property :category_id, Integer
  property :slug, Slug, :length => 255
  property :title, String, :length => 255
  property :body, Text
  property :type, Discriminator
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user
  belongs_to :category, :required => false
  has n, :comments

  has_tags

  default_scope(:default).update(:order => [:created_at.desc])

  validates_presence_of :title
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  def self.get_by_fuzzy_slug(str)
    if ret = first(:slug => str)
      ret
    else
      first(:id => str)
    end
  end

  def self.search(str)
    all(:title.like => "%#{str}%") |
    all(:body.like => "%#{str}%")
  end

  def self.recent(count)
    all(:limit => count, :order => [:created_at.desc])
  end

  def fuzzy_slug
    slug || id
  end

  def link
    "/#{fuzzy_slug}"
  end

  def tags_to_html
    html = '<ul>'
    tags.each do |tag|
      html += %Q(<li><a href="#{tag.link}">#{tag.name}</a></li>)
    end
    html + '</ul>'
  end
end

class Post < Entry; end
class Page < Entry; end
