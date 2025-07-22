class Comment < ApplicationRecord
  belongs_to :entry
  
  enum status: { pending: 0, approved: 1, spam: 2 }
  
  validates :name, presence: true
  validates :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  
  scope :recent, -> { order(created_at: :desc) }
  
  def gravatar_url(size = 50)
    return nil if email.blank?
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end
end
