# frozen_string_literal: true

class FieldName
  include DataMapper::Resource

  property :id, Serial
  property :name, String, length: 255
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_with_method :validate_if_entry_respond_to

  def validate_if_entry_respond_to
    entry = Entry.new
    return true unless entry.respond_to?(name, true)
    [false, "'#{name}' cannot be used because Entry has a method of the same name"]
  end
end

def FieldName(id)
  FieldName.get(id)
end
