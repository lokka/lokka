# frozen_string_literal: true

class Theme
  attr_reader :name, :root_dir, :root_path, :dir, :path, :i18n_dir

  def initialize(root_dir, root_path, mobile = false)
    @root_dir = root_dir
    @root_path = "#{root_path}/theme"
    site = Site.first
    mobile_theme = site.mobile_theme.blank? ? site.theme : site.mobile_theme
    @name = mobile ? mobile_theme : site.theme
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
