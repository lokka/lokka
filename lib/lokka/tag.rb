class Tag
  def link
    "/tags/#{name}/"
  end
end

def Tag(name)
  Tag.first(:name => name)
end
