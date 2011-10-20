# encoding: utf-8
class Entry
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer
  property :category_id, Integer
  property :slug, Slug, :length => 255
  property :title, String, :length => 255
  property :body, Text
  property :type, Discriminator
  property :draft, Boolean, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user
  belongs_to :category, :required => false
  has n, :comments, :status

  has_tags

  validates_presence_of :title
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  before :valid? do
    self.category_id = nil if category_id === ''
  end

  def comments
    @comment = Comment.all(:status => Comment::APPROVED, :entry_id => self.id)
  end

  def tag_collection=(string)
    reg = RUBY_VERSION >= "1.9.0" ? /[^\p{Word}._]/iu : /[^\w\s._-]/i
    @tag_list = string.to_s.split(',').map { |name|
      name.force_encoding(Encoding.default_external).gsub(reg, '').strip
    }.reject{|x|x.blank?}.uniq.sort
  end

  class << self
    def _default_scope
      {:order => :created_at.desc}
    end

    def first_with_scope(limit, query = DataMapper::Undefined)
      unless limit.kind_of? Integer
        query = limit
        limit = 1
      end
      query = _default_scope.update(query) if query.kind_of? Hash
      query = _default_scope if query == DataMapper::Undefined
      first_without_scope query
    end
    alias_method_chain :first, :scope

    def all_with_scope(query = DataMapper::Undefined)
      query = _default_scope.update(query) if query.kind_of? Hash
      query = _default_scope if query == DataMapper::Undefined
      all_without_scope query
    end
    alias_method_chain :all, :scope
  end

  def self.get_by_fuzzy_slug(str, query = {})
    query = {:draft => false}.update(query)
    ret = first({:slug => str}.update(query))
    ret.blank? ? first({:id => str}.update(query)) : ret
  end

  def self.search(str)
    all(:title.like => "%#{str}%") |
      all(:body.like => "%#{str}%")
  end

  def self.recent(count = 5)
    all(:limit => count)
  end

  def self.published
    all(:draft => false)
  end

  def self.unpublished
    all(:draft => true)
  end

  def fuzzy_slug
    slug.blank? ? id : slug
  end

  def link
    "/#{fuzzy_slug}"
  end

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end

  def tags_to_html
    html = '<ul class="tags">'
    tags.each do |tag|
      html += %Q(<li class="tag"><a href="#{tag.link}">#{tag.name}</a></li>)
    end
    html + '</ul>'
  end
end

def Entry(id_or_slug)
  Entry.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Post < Entry; end

def Post(id_or_slug)
  Post.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Page < Entry; end

def Page(id_or_slug)
  Page.get_by_fuzzy_slug(id_or_slug.to_s)
end
