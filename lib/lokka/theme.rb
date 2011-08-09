# encoding: utf-8
class Theme
  attr_reader :name, :root_dir, :root_path, :dir, :path, :i18n_dir

  def initialize(root_dir)
    @root_dir = root_dir
    @root_path = '/theme'
    @name = Site.first.theme
    @dir = "#{@root_dir}/#{@name}"
    @path = "#{@root_path}/#{@name}"
    @i18n_dir = "#{@dir}/i18n"
  end

  def to_path(name)
    "#{@dir}/#{name}"
  end

  def exist_i18n?
    File.exist? @i18n_dir
  end
end
