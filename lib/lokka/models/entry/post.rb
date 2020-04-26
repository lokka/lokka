class Post < Entry
  alias orig_link link
  def link
    if Lokka::PermalinkHelper.custom_permalink?
      param = {
        year: created_at.year.to_s.rjust(4, '0'),
        month: created_at.month.to_s.rjust(2, '0'),
        day: created_at.day.to_s.rjust(2, '0'),
        hour: created_at.hour.to_s.rjust(2, '0'),
        minute: created_at.min.to_s.rjust(2, '0'),
        second: created_at.sec.to_s.rjust(2, '0'),
        id: id.to_s,
        slug: slug || ''
      }
      Lokka::PermalinkHelper.custom_permalink_path(param)
    else
      orig_link
    end
  end

  def next
    Post.where('id > ?', self.id).order('id').limit(1).first
  end

  def prev
    Post.where('id < ?', self.id).order('id desc').limit(1).first
  end
end
