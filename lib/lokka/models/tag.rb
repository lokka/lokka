# frozen_string_literal: true

class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def link
    "/tags/#{name}/"
  end
end

##
# Retrieving Tag.
#
# @param [String] Tag name
# @return [Tag] Tag instance
def Tag(name)
  Tag.find_by(name: name)
end
