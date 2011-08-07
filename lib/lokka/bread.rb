class Bread
  attr_accessor :name, :link, :last

  def initialize(name, link, last = false)
    @name = name
    @link = link
    @last = last
  end

  def last?
    !!@last
  end
end
