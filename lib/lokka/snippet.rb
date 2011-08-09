# encoding: utf-8
class Snippet
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

def Snippet(name)
  Snippet.first(:name => name)
end
