# frozen_string_literal: true

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :tag, presence: true
  validates :taggable, presence: true
  validates :taggable_type, presence: true
end
