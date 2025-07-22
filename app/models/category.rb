class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :entries, dependent: :nullify
  
  validates :name, presence: true, uniqueness: true
  validates :slug, format: { with: /\A[_\/0-9a-zA-Z-]+\z/ }, allow_blank: true
  
  def link
    "/categories/#{slug}"
  end
end
