class Site
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :value, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  def self.value(name)
    first(:name => name).value
  end

  def self.to_ostruct
    hash = {}
    all.each do |site|
      hash[site.name.to_sym] = site.value
    end
    OpenStruct.new(hash)
  end
end
