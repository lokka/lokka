# frozen_string_literal: true

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :tag_id,        presence: true
  validates :taggable_type, presence: true
  validates :taggable_id,   presence: true

  def self.tagged!(parent, tag_list)
    transaction do
      created_tags = Tag.where_or_create(tag_list)
      parent.tags = created_tags
    end
  end
end
