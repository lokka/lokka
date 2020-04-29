class Entry < ActiveRecord::Base
  attr_accessible :user,
                  :category_id,
                  :slug,
                  :title,
                  :body,
                  :markup,
                  :type,
                  :draft,
                  :created_at,
                  :updated_at

  has_many :comments
  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  belongs_to :user
  belongs_to :category

  validates :title, presence:   true
  validates :slug, uniqueness: true,
                   format: %r{^[_/0-9a-zA-Z-]+$}, allow_blank: true

  validate :validate_confliction
  after_save :update_fields

  default_scope { order('created_at DESC') }
  scope :published,   ->{ where(draft: false) }
  scope :unpublished, ->{ where(draft: true) }
  scope :posts,       ->{ where(type: 'Post') }
  scope :pages,       ->{ where(type: 'Page') }
  scope :recent,
    ->(count = 5){ limit(count) }
  scope :between_a_year,
    ->(time){
    where(created_at: time.beginning_of_year..time.end_of_year)
  }
  scope :between_a_month,
    ->(time){
    where(created_at: time.beginning_of_month..time.end_of_month)
  }
  scope :search,
    ->(word){
      where('title LIKE ?', "#{word}") | where('body LIKE ?', "#{word}")
  }

  def self.get_by_fuzzy_slug(id_or_slug)
    where(slug: id_or_slug).first || where(id: id_or_slug).first
  end

  def long_body
    Markup.use_engine(markup, self.body)
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

  def tagged_with(string)
    Tagging.tagged!(self, string)
  end

  def tag_list
    tags.pluck(:name)
  end

  def tag_collection
    tag_list.join(',')
  end

  def tags_to_html
    html = '<ul class="tags">'
    self.tags.each do |tag|
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
    if @updated_at == self.class.find(id).updated_at
      return true
    else
      return [false, "The entry is updated while you were editing"]
    end
  end

  def method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      field_name = FieldName.where(name: column).first
      field = Field.where(entry_id: self.id, field_name_id: field_name.id).first
      if field
        field.value = args.first
      else
        field = Field.new(entry_id: self.id, field_name_id: field_name.id, value: args.first)
      end
      field.save
    else
      field_name = FieldName.where(name: attribute).first
      field = Field.where(entry_id: self.id, field_name_id: field_name.id).first
      field.try(:value)
    end
  end
end
