class Theme
  attr_reader :name, :root_dir, :root_path, :dir, :path

  def initialize(root_dir)
    @root_dir = root_dir
    @root_path = '/theme'
    @name = Site.first.theme
    @dir = "#{@root_dir}/#{@name}"
    @path = "#{@root_path}/#{@name}"
  end

  def to_path(name)
    "#{@dir}/#{name}"
  end
end
