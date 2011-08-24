# encoding: utf-8
class Option
  include DataMapper::Resource

  property :name, String, :length => 255, :key => true
  property :value, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      o = self.first_or_new(:name => column)
      o.value = args.first
      o.save
    else
      o = self.first_or_new(:name => method)
      o.value
    end
  end
end
