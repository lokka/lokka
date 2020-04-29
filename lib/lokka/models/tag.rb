# frozen_string_literal: true

class Tag < ActiveRecord::Base
  has_many :taggings,
           dependent: :destroy
  has_many :entries,
           through: :taggings,
           source: :tag,
           class_name: 'Entry'

  validates :name,
            presence: true,
            uniqueness: true

  scope :any,
        lambda {|list|
          where(list.map {|name| sanitize_sql(['name = ?', name]) }.join(' OR '))
        }

  def link
    "/tags/#{name}"
  end

  def self.where_or_create(str)
    list = str.split(',')
    existing_tags = Tag.any(list)
    new_tag_names = list.reject do |name|
      existing_tags.any? {|tag| tag.name == name }
    end
    created_tags = new_tag_names.map {|name| Tag.create(name: name) }

    existing_tags + created_tags
  end
end

def Tag(name)
  Tag.where(name: name).first
end
