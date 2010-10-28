class UploadFile
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => (1..255), :unique => true
  property :path, String, :default => Proc.new { Date.today.to_s.split('-').join }
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :path

  def self.search(str)
    first(:name => str)
  end

  def link
    "/upload_files/#{path}/#{CGI.escape(name)}"
  end
end
