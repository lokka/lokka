class Entry < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  
  Gutentag::ActiveRecord.call self
  
  validates :title, presence: true, uniqueness: true
  validates :slug, format: { with: /\A[_\/0-9a-zA-Z-]+\z/ }, allow_blank: true
  
  scope :published, -> { where(draft: false) }
  scope :drafts, -> { where(draft: true) }
  
  before_save :set_markup_default
  
  def long_body
    case markup
    when 'markdown'
      Kramdown::Document.new(body.to_s).to_html.html_safe
    when 'redcarpet'
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render(body.to_s).html_safe
    else
      body.to_s.html_safe
    end
  end
  
  def short_body
    long_body.sub(/<!-- ?more ?-->.*/m, "<a href=\"#{link}\">#{I18n.t('continue_reading')}</a>").html_safe
  end
  
  def link
    "/#{self.class.name.downcase.pluralize}/#{slug}"
  end
  
  def approved_comments
    comments.where(status: Comment.statuses[:approved])
  end
  
  private
  
  def set_markup_default
    self.markup ||= 'html'
  end
  
  def tag_names
    tags.pluck(:name)
  end
  
  def tag_names=(names)
    self.tag_names = names.to_s.split(',').map(&:strip).reject(&:blank?)
  end
end
