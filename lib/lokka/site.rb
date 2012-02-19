# encoding: utf-8
class Site
  include DataMapper::Resource

  SORT_COLUMNS = %w(id created_at updated_at)
  ORDERS = %w(asc desc)

  property :id, Serial
  property :title, String, :length => 255
  property :description, String, :length => 255
  property :dashboard, Text, :length => 65535
  property :theme, String, :length => 64
  property :mobile_theme, String, :length => 64
  property :per_page, Integer
  property :default_sort, String, :length => 255
  property :default_order, String, :length => 255
  property :meta_description, String, :length => 255
  property :meta_keywords, String, :length => 255
  property :created_at, DateTime
  property :updated_at, DateTime

  def per_page
    super || '10'
  end

  def default_sort
    super || 'created_at'
  end

  def default_order
    super || 'desc'
  end

  def default_order_query_operator
    default_sort.to_sym.send(default_order)
  end

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
