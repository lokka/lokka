# frozen_string_literal: true

class Category < ActiveRecord::Base
  attr_accessible :title, :slug, :description, :parent_id

  has_many :entries

  validates :title, presence:   true,
                    uniqueness: true
  validates :slug,  presence:   true

  scope :without_self,
    ->(id){ self.where("id NOT IN (?)", id) }

  def self.get_by_fuzzy_slug(string)
    ret = where(slug: string).first || where(title: string).first
  end

  def fuzzy_slug
    slug.blank? ? title : slug
  end

  def link
    "/category/#{fuzzy_slug}"
  end

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end

  def parent
    Category.find(self.parent_id)
  end
end

def Category(id_or_slug)
  Category.get_by_fuzzy_slug(id_or_slug.to_s)
end
