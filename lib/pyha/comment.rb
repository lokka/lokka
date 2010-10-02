class Comment
  include DataMapper::Resource

  property :id, Serial
  property :entry_id, Integer
  property :name, String
  property :homepage, String
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :entry

  default_scope(:default).update(:order => :created_at.desc)

  validates_presence_of :name
  validates_presence_of :body

  def self.recent(count = 5)
    all(:limit => count, :order => [:created_at.desc])
  end

  def link
    "#{self.entry.link}#comment-#{id}"
  end
end
