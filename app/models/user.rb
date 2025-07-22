class User < ApplicationRecord
  has_secure_password
  
  has_many :entries, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true, length: { in: 3..40 }
  validates :email, presence: true, uniqueness: true, length: { in: 5..40 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 4 }, if: -> { new_record? || !password.nil? }
  
  before_validation :strip_name
  
  def admin?
    permission_level == 1
  end
  
  private
  
  def strip_name
    self.name = name.to_s.strip
  end
end
