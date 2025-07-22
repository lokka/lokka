class Post < Entry
  default_scope -> { order(created_at: :desc) }
  
  def link
    "/posts/#{slug}"
  end
end