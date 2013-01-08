class User < ActiveRecord::Base
  has_many :entries

  attr_accessor :password, :password_confirmation

  validates :name,
    presence:   true,
    uniqueness: true,
    length:     (3..40)
  validates :email,
    uniqueness: true,
    length:     (5..40), allow_blank: true
  validates :password,
    length: { minimum: 4 },
    confirmation: true,
    if: :password_require?

  validates :password_confirmation,
    presence: true,
    if: :password_require?

  before_validation do
    self.name = name.strip
  end

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt) if !@password.blank?
  end

  def self.authenticate(name, pass)
    current_user = where(name: name).first
    return nil if current_user.nil?
    return current_user if User.encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end

  def admin?
    permission_level == 1
  end

  def password_require?
    self.new_record? || (!self.new_record? && !self.password.blank?)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    Array.new(len) { ['a'..'z','A'..'Z','0'..'9'].map(&:to_a).flatten[rand(62)] }.join
  end
end

class Hash
  def stringify
    inject({}) do |options, (key, value)|
      options[key.to_s] = value.to_s
      options
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
