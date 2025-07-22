class Page < Entry
  default_scope -> { order(:title) }
  
  def link
    "/pages/#{slug}"
  end
end