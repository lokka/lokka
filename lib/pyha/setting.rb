class Setting
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :value, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  def self.theme
    first(:name => 'theme').value
  end
end
