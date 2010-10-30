class Site
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255
  property :description, String, :length => 255
  property :theme, String, :length => 64
  property :created_at, DateTime
  property :updated_at, DateTime

  def method_missing(method, *args)
    Option.send(method, args)
  end
end
