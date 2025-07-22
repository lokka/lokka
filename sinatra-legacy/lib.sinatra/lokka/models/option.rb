# frozen_string_literal: true

class Option
  include DataMapper::Resource

  property :name, String, length: 255, key: true
  property :value, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      option = first_or_new(name: column)
      option.value = args.first.to_s
      option.save
    else
      option = first_or_new(name: method.to_s)
      option.value
    end
  end
end
