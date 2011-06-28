class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => (3..40), :unique => true
  property :email, String, :length => (5..40), :unique => true, :format => :email_address
  property :hashed_password, String
  property :salt, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :permission_level, Integer, :default => 1

  has n, :entries

  attr_accessor :password, :password_confirmation

  validates_uniqueness_of :name
  validates_uniqueness_of :email
  validates_length_of :password, :minimum => 4, :if => :password_require?
  validates_presence_of :password_confirmation, :if => :password_require?
  validates_confirmation_of :password

  before :valid? do
    self.name = name.strip
  end

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt) if !@password.blank?
  end

  def self.authenticate(name, pass)
    current_user = first(:name => name)
    return nil if current_user.nil?
    return current_user if User.encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end

  def admin?
    permission_level == 1
  end

  def password_require?
    self.new? || (!self.new? && !self.password.blank?)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
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
