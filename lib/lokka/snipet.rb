class Snipet
  include DataMapper::Resource

  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :body

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end
end
