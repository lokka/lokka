class Bread
  attr_accessor :name, :link, :last

  def initialize(name, link, last = false)
    @name = name
    @link = link
    @last = last
  end

  def last?
    @last
  end
end

class BreadCrumb
  include Enumerable
  attr_accessor :breads

  def initialize(breads = [])
    @breads = breads

  end

  def add(name, link)
    @breads << Bread.new(name, link)
  end

  def each
    @breads.last.last = true
    @breads.each do |bread|
      yield bread
    end
  end
end
