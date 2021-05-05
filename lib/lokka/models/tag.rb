# frozen_string_literal: true

class Tag < ActiveRecord::Base
  has_many :taggings,
           dependent: :destroy
  has_many :entries,
           through: :taggings,
           source: :taggable,
           source_type: 'Entry'

  validates :name,
            presence: true,
            uniqueness: true

  scope :any,
        ->(list) {
          where(list.map {|name| sanitize_sql(['name = ?', name]) }.join(' OR '))
        }

  def link
    "/tags/#{name}"
  end
end

def Tag(name)
  Tag.where(name: name).first
end
