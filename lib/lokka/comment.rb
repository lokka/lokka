# encoding: utf-8
class Comment
  include DataMapper::Resource

  MODERATED = 0
  APPROVED  = 1
  SPAM      = 2

  property :id, Serial
  property :entry_id, Integer
  property :status, Integer # 0 => moderated, 1 => approved
  property :name, String
  property :email, String, :length => (5..40), :format => :email_address
  property :homepage, String
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :entry

  default_scope(:default).update(:order => :created_at.desc)

  validates_presence_of :name
  validates_presence_of :body

  def self.recent(count = 5)
    all(:status => APPROVED, :limit => count, :order => [:created_at.desc])
  end

  def self.moderated
    all(:status => MODERATED)
  end

  def self.approved
    all(:status => APPROVED)
  end

  def self.spam
    all(:status => SPAM)
  end

  def link
    "#{self.entry.link}#comment-#{id}"
  end
end

def Comment(id)
  Comment.get(id)
end
