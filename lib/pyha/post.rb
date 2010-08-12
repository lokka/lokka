class Post
  include DataMapper::Resource

  property :id, Serial
  property :slug, Slug, :length => 255
  property :title, String, :length => 255
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  def link
    "/#{id}"
  end

=begin
  has n, :chirps
  has n, :direct_messages, :class_name => "Chirp"
  has n, :relationships
  has n, :followers, :through => :relationships, :class_name => "User", :child_key => [:user_id]
  has n, :follows, :through => :relationships, :class_name => "User", :remote_name => :user, :child_key => [:follower_id]

  def self.find(identifier)
    u = first(:identifier => identifier)
    u = new(:identifier => identifier) if u.nil?
    return u
  end

  def displayed_chirps
    chirps = []
    chirps += self.chirps.all(:recipient_id => nil, :limit => 10, :order => [:created_at.desc]) # don't show direct messsages
    self.follows.each do |follows| chirps += follows.chirps.all(:recipient_id => nil, :limit => 10, :order => [:created_at.desc]) end if @myself == @user
    chirps.sort! { |x,y| y.created_at <=> x.created_at }
    chirps[0..10]
  end
=end

end
