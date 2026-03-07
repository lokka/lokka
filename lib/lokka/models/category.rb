# frozen_string_literal: true

class Category < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id, dependent: :nullify
  has_many :entries

  validates :title, presence: true, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true

  scope :roots, -> { where(parent_id: nil) }

  def self.get_by_fuzzy_slug(str)
    ret = find_by(slug: str)
    ret.blank? ? find_by(id: str) : ret
  end

  def ancestors
    result = []
    current = parent
    while current
      result.unshift(current)
      current = current.parent
    end
    result
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

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end
end

def Category(id_or_slug)
  Category.get_by_fuzzy_slug(id_or_slug.to_s)
end
