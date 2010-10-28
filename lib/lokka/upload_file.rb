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

  def upload(settings, tempfile)
    absolute_path = File.join(settings.upload_files, path)
    FileUtils.mkdir_p(absolute_path) unless File.exist? path
    while tmp = tempfile.read(65535)
      File.open(File.join(absolute_path, name), "wb") do |f| 
        f.write(tmp)
      end 
    end 
  end

  def remove(settings)
    absolute_path = File.join(settings.upload_files, path)
    FileUtils.rm_f(File.join(absolute_path, name))
    Dir.chdir(absolute_path)
    FileUtils.rm_rf(absolute_path) if Dir["*"].length == 0
  end
end
