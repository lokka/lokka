# frozen_string_literal: true

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :fields, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :slug, uniqueness: true, format: { with: %r{\A[_/0-9a-zA-Z-]+\z} }, allow_blank: true
  validate :validate_confliction

  before_validation :clear_blank_category_id
  after_save :update_fields

  default_scope { order(created_at: :desc) }

  scope :published, -> { where(draft: false) }
  scope :unpublished, -> { where(draft: true) }

  alias raw_body body

  def long_body
    Markup.use_engine(markup, raw_body.to_s)
  end
  alias_method :rendered_body, :long_body

  def short_body
    @short_body ||= long_body. \
                      sub(/<!-- ?more ?-->.*/m, "<a href=\"#{link}\">#{I18n.t('continue_reading')}</a>").html_safe
  end

  def approved_comments
    Comment.where(status: Comment::APPROVED, entry_id: id)
  end

  def tag_collection=(string)
    reg = /[^\p{Word}._]/iu
    @tag_list = string.to_s.split(',').map do |name|
      name.force_encoding(Encoding.default_external).gsub(reg, '').strip
    end
    @tag_list = @tag_list.reject(&:blank?).uniq.sort

    update_tags
  end

  def tag_list
    tags.map(&:name)
  end

  def update_tags
    return unless @tag_list
    self.taggings.destroy_all
    @tag_list.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      self.taggings.find_or_create_by(tag: tag, tag_context: 'tags')
    end
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
      html += %(<li class="tag"><a href="#{tag.link}">#{tag.name}</a></li>)
    end
    html += '</ul>'
    html.html_safe
  end

  # custom fields
  attr_writer :fields_hash

  def update_fields
    return unless @fields_hash
    @fields_hash.each do |k, v|
      send("#{k}=", v)
    end
  end

  def validate_confliction
    return unless id && @updated_at_before_edit
    current = self.class.find_by(id: id)
    return unless current
    return if @updated_at_before_edit == current.updated_at
    errors.add(:updated_at, 'The entry is updated while you were editing')
  end

  def method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      field_name = FieldName.find_by(name: column)
      return super unless field_name
      field = Field.find_by(entry_id: id, field_name_id: field_name.id)
      if field
        field.update(value: args.first)
      else
        Field.create(entry_id: id, field_name_id: field_name.id, value: args.first)
      end
    else
      field_name = FieldName.find_by(name: attribute)
      return super unless field_name
      field = Field.find_by(entry_id: id, field_name_id: field_name.id)
      field.try(:value)
    end
  end

  def respond_to_missing?(method, include_private = false)
    attribute = method.to_s.sub(/=$/, '')
    FieldName.exists?(name: attribute) || super
  end

  def description
    src = long_body.tr("\n", '')
    desc = src =~ %r{<p[^>]*>(.+?)</p>}i ? Regexp.last_match(1) : src[0..50]
    desc.to_s.gsub(%r{<[^/]+/>}, ' ').gsub(%r{</[^/]+>}, ' ').gsub(/<[^>]+>/, '').html_safe
  end

  class << self
    def get(id)
      find_by(id: id)
    end

    def get_by_fuzzy_slug(str, query = {})
      query = { draft: false }.merge(query)
      ret = find_by({ slug: str }.merge(query))
      ret.blank? ? find_by({ id: str }.merge(query)) : ret
    end

    def search(str)
      where('title LIKE ? OR body LIKE ?', "%#{str}%", "%#{str}%")
    end

    def recent(count = 5)
      published.limit(count)
    end
  end

  private

  def clear_blank_category_id
    self.category_id = nil if category_id.to_s == ''
  end
end

def Entry(id_or_slug)
  Entry.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Post < Entry
  alias orig_link link
  def link
    if Lokka::Helpers.custom_permalink?
      Lokka::Helpers.custom_permalink_path(year: created_at.year.to_s.rjust(4, '0'),
                                           monthnum: created_at.month.to_s.rjust(2, '0'),
                                           month: created_at.month.to_s.rjust(2, '0'),
                                           day: created_at.day.to_s.rjust(2, '0'),
                                           hour: created_at.hour.to_s.rjust(2, '0'),
                                           minute: created_at.min.to_s.rjust(2, '0'),
                                           second: created_at.sec.to_s.rjust(2, '0'),
                                           post_id: id.to_s,
                                           id: id.to_s,
                                           slug: slug || id.to_s,
                                           postname: slug || id.to_s,
                                           category: category ? (category.slug || category.id.to_s) : '')
    else
      orig_link
    end
  end

  def next
    @next ||= self.class.unscoped.where(draft: false).where('created_at > ?', created_at).order(created_at: :asc).first
  end

  def prev
    @prev ||= self.class.unscoped.where(draft: false).where('created_at < ?', created_at).order(created_at: :desc).first
  end
end

def Post(id_or_slug)
  Post.get_by_fuzzy_slug(id_or_slug.to_s)
end

class Page < Entry; end

def Page(id_or_slug)
  Page.get_by_fuzzy_slug(id_or_slug.to_s)
end
