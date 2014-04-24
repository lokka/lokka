class Post < Entry
  def next
    Post.where('id > ?', self.id).order('id').limit(1).first
  end

  def prev
    Post.where('id < ?', self.id).order('id desc').limit(1).first
  end
end
