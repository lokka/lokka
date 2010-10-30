class UploadFile
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => (1..255)
  property :name, String, :length => (1..255), :unique => true
  property :filetype, String
  property :filesize, Integer
  property :path, String, :default => Proc.new { Date.today.to_s.split('-').join }
  property :data, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name
  validates_presence_of :title
  validates_presence_of :name
  validates_presence_of :filetype
  validates_presence_of :filesize
  validates_presence_of :path

  READ_BUFFER = 65535

  def upload(settings, tempfile)
    __send__('upload_' + settings.upload_type, settings, tempfile)
  end

  def remove(settings)
    __send__('remove_' + settings.upload_type, settings)
  end

  def download(settings)
    __send__('download_' + settings.upload_type, settings)
  end

  # db
  def upload_db(settings, tempfile)
    self.data = [tempfile.read].pack('m')
    self.save!
  end

  def remove_db(settings)
  end

  def download_db(settings)
    data.unpack('m')[0]
  end

  # file
  def upload_file(settings, tempfile)
    absolute_path = File.join(settings.upload_files, path)
    FileUtils.mkdir_p(absolute_path) unless File.exist? path
    size = tempfile.size
    read_size = size < READ_BUFFER ? size : READ_BUFFER
    while tmp = tempfile.read(read_size)
      File.open(File.join(absolute_path, name), "ab") { |f| f.write(tmp) }
      size = size - read_size
      read_size = size < READ_BUFFER ? size : READ_BUFFER
      break if read_size <= 0
    end 
  end

  def remove_file(settings)
    absolute_path = File.join(settings.upload_files, path)
    FileUtils.rm_f(File.join(absolute_path, name))
    Dir.chdir(absolute_path)
    FileUtils.rm_rf(absolute_path) if Dir["*"].length == 0
  end

  def download_file(settings)
    file = File.join(settings.upload_files, path, name)
    File.exist?(file) ? file : nil
  end

  # helper
  def file_readable_size 
    if filesize.to_f / 1024 >= 1024
      sprintf("%.1fMB", filesize.to_f / 1024 / 1024) 
    elsif filesize.to_f / 1024 >= 1
      sprintf("%.fKB", filesize.to_f / 1024) 
    else
      filesize.to_s + "byte" + (filesize > 1 ? "s" : "")
    end
  end
end
