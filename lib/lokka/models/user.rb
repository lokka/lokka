# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :entries
  has_secure_password

  validates :name, {
    presence: true,
    uniqueness: true,
    length: (3..40)
  }
  validates :email, {
    presence: true,
    uniqueness: true,
    length: (5..40)
  }
  validates :password, {
    length: { minimum: 4 },
    confirmation: true,
    if: :password_require?
  }
  validates :password_confirmation, {
    presence: true,
    if: :password_require?
  }

  before_validation do
    self.name = name.strip
  end

  def password_require?
    new_record?
  end

  def admin?
    permission_level == 1
  end

  def authenticate(password)
    return hashed_password == Digest::SHA1.hexdigest(password + salt) if aged_user?

    super
  end

  def aged_user?
    respond_to?(:hashed_password) && respond_to?(:salt)
  end
end

class GuestUser
  def admin?
    false
  end

  def permission_level
    0
  end
end
