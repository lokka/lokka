# encoding: utf-8
class BreadCrumb
  include Enumerable
  attr_accessor :breads

  def initialize(breads = [])
    @breads = breads

  end

  def add(name, link = nil)
    @breads << Bread.new(name, link)
  end

  def each
    @breads.last.last = true
    @breads.each do |bread|
      yield bread
    end
  end
end
