class Post < Entry
  alias orig_link link
  def link
    if Lokka::Helpers.custom_permalink?
      Lokka::Helpers.custom_permalink_path({
        :year     => self.created_at.year.to_s.rjust(4,'0'),
        :monthnum => self.created_at.month.to_s.rjust(2,'0'),
        :month    => self.created_at.month.to_s.rjust(2,'0'),
        :day      => self.created_at.day.to_s.rjust(2,'0'),
        :hour     => self.created_at.hour.to_s.rjust(2,'0'),
        :minute   => self.created_at.min.to_s.rjust(2,'0'),
        :second   => self.created_at.sec.to_s.rjust(2,'0'),
        :post_id  => self.id.to_s,
        :id       => self.id.to_s,
        :slug     => self.slug || self.id.to_s,
        :postname => self.slug || self.id.to_s,
        :category => self.category ? (self.category.slug || self.category.id.to_s) : ""
      })
    else
      orig_link
    end
  end

  def next
    where('id > ?', id).order('id').limit(1).first
  end

  def prev
    where('id < ?', id).order('id desc').limit(1).first
  end
end
