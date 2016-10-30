# encoding: utf-8
class Entry
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer
  property :category_id, Integer
  property :slug, Slug, :length => 255
  property :title, String, :length => 255
  property :body, Text
  property :markup, String, :length => 255
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
  validates_with_method :updated_at, :method => :validate_confliction
  validates_format_of :slug, :with => %r{^[_/0-9a-zA-Z-]+$}

  before :valid? do
    self.category_id = nil if category_id === ''
  end

  after :save, :update_fields

  alias_method :raw_body, :body
  def long_body
    Markup.use_engine(markup, raw_body)
  end
  alias_method :body, :long_body

  def short_body
    @short_body ||= self.long_body \
      .sub(/<!-- ?more ?-->.*/m, "<a href=\"#{link}\">#{I18n.t('continue_reading')}</a>")
  end

  def comments
    @comment = Comment.all(:status => Comment::APPROVED, :entry_id => self.id)
  end

  def tag_collection=(string)
    reg = /[^\p{Word}._]/iu
    @tag_list = string.to_s.split(",").map { |name|
      name.force_encoding(Encoding.default_external).gsub(reg, "").strip
    }
    @tag_list = @tag_list.reject(&:blank?).uniq.sort

    update_tags
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

  # custom fields
  def fields=(hash)
    @fields = hash
  end

  def update_fields
    return unless @fields
    @fields.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def validate_confliction
    return true unless id
    if @updated_at == self.class.get(id).updated_at
      return true
    else
      return [false, "The entry is updated while you were editing"]
    end
  end

  def method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      field_name = FieldName.first(:name => column)
      field = Field.first(:entry_id => self.id, :field_name_id => field_name.id)
      if field
        field.value = args.first
      else
        field = Field.new(:entry_id => self.id, :field_name_id => field_name.id, :value => args.first)
      end
      field.save
    else
      field_name = FieldName.first(:name => attribute)
      field = Field.first(:entry_id => self.id, :field_name_id => field_name.id)
      field.try(:value)
    end
  end

  def description
    src = self.long_body.tr("\n", "")
    desc = ((src =~ %r!<p[^>]*>(.+?)</p>!i)? $1: src[0..50])
    return desc.gsub(%r!<[^/]+/>!,' ').gsub(%r!</[^/]+>!,' ').gsub(/<[^>]+>/,'')
  end

  class << self
    def _default_scope
      {:order => :created_at.desc}
    end

    def first_with_scope(limit = 1, query = DataMapper::Undefined)
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

    def get_by_fuzzy_slug(str, query = {})
      query = {:draft => false}.update(query)
      ret = first({:slug => str}.update(query))
      ret.blank? ? first({:id => str}.update(query)) : ret
    end

    def search(str)
      all(:title.like => "%#{str}%") |
        all(:body.like => "%#{str}%")
    end

    def recent(count = 5)
      all(:draft => false, :limit => count)
    end

    def published
      all(:draft => false)
    end

    def unpublished
      all(:draft => true)
    end
  end
end

def Entry(id_or_slug)
  Entry.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Post < Entry
  alias orig_link link
  def link
    if Lokka::Helpers.custom_permalink?
      Lokka::Helpers.custom_permalink_path({
        :year     => self.created_at.year.to_s.rjust(4,'0'),
        :monthnum => self.created_at.month.to_s.rjust(2,'0'),
        :month    => self.created_at.month.to_s.rjust(2,'0'),
        :day      => self.created_at.day.to_s.rjust(2,'0'),
        :hour     => self.created_at.hour.to_s.rjust(2,'0'),
        :minute   => self.created_at.min.to_s.rjust(2,'0'),
        :second   => self.created_at.sec.to_s.rjust(2,'0'),
        :post_id  => self.id.to_s,
        :id       => self.id.to_s,
        :slug     => self.slug || self.id.to_s,
        :postname => self.slug || self.id.to_s,
        :category => self.category ? (self.category.slug || self.category.id.to_s) : ""
      })
    else
      orig_link
    end
  end

  def next
    @next ||= self.class.first(
      :draft => false,
      :created_at.gt => self.created_at,
      :order => [:created_at.asc])
  end

  def prev
    @prev ||= self.class.first(
      :draft => false,
      :created_at.lt => self.created_at,
      :order => [:created_at.desc])
  end
end

def Post(id_or_slug)
  Post.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Page < Entry; end

def Page(id_or_slug)
  Page.get_by_fuzzy_slug(id_or_slug.to_s)
end
