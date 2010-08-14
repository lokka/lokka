class Post
  include DataMapper::Resource

  property :id, Serial
  property :slug, String, :length => 255
  property :title, String, :length => 255
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user

  def link
    "/#{id}"
  end
end
