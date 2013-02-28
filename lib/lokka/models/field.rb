class Field
  include DataMapper::Resource

  property :id, Serial
  property :field_name_id, Integer
  property :entry_id, Integer
  property :value, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :field_name
  belongs_to :entry
end