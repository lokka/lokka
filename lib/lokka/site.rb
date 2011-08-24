# encoding: utf-8
class Site
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255
  property :description, String, :length => 255
  property :dashboard, Text, :length => 65535
  property :theme, String, :length => 64
  property :mobile_theme, String, :length => 64
  property :meta_description, String, :length => 255
  property :meta_keywords, String, :length => 255
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

def Site
  Site.get(1)
end
