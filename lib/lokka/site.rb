class Site
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255
  property :description, String, :length => 255
  property :theme, String, :length => 64
  property :created_at, DateTime
  property :updated_at, DateTime

  def method_missing(method, *args)
    if method.to_s =~ /=$/
      super
    else
      o = Option.first_or_new(:name => method)
      o.value
    end
  end
end
