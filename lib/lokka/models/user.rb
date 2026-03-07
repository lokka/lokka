# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :entries

  validates :name, presence: true, uniqueness: true, length: { in: 3..40 }
  validates :email, presence: true, uniqueness: true, length: { in: 5..40 },
                    format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :password, length: { minimum: 4 }, if: :password_require?
  validates :password_confirmation, presence: true, if: :password_require?
  validates_confirmation_of :password

  attr_accessor :password_confirmation
  attr_reader :password

  before_validation :strip_name

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) unless salt
    self.hashed_password = User.encrypt(@password, salt) unless @password.blank?
  end

  def self.authenticate(name, pass)
    current_user = find_by(name: name)
    return nil if current_user.nil?
    return current_user if User.encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end

  def self.get(id)
    find_by(id: id)
  end

  def admin?
    permission_level == 1
  end

  def password_require?
    new_record? || !password.blank?
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end

  def self.random_string(len)
    Array.new(len) { ['a'..'z', 'A'..'Z', '0'..'9'].map(&:to_a).flatten[rand(62)] }.join
  end

  private

  def strip_name
    self.name = name.strip if name
  end
end

class Hash
  def stringify
    each_with_object({}) do |(key, value), options|
      options[key.to_s] = value.to_s
    end
  end

  def stringify!
    each do |key, value|
      delete(key)
      store(key.to_s, value.to_s)
    end
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
