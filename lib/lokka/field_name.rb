class FieldName
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name
end

def FieldName(id)
  FieldName.get(id)
end