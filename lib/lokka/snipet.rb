class Snipet
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name
  validates_presence_of :body
  validates_uniqueness_of :name

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end
end

def Snipet(name)
  Snipet.first(:name => name)
end
