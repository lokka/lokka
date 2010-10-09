class Site
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255
  property :description, String, :length => 255
  property :theme, String, :length => 64
  property :created_at, DateTime
  property :updated_at, DateTime

  private
  def define_field_accessor(name)
    define_method(name) do
      first(:name => name).value
    end

    define_method("#{name}=") do |value|
      first(:name => name).value = value
    end
  end
end
