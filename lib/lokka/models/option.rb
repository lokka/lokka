class Option < ActiveRecord::Base
  attr_accessible :name

  validates :name,
    presence:   true,
    uniqueness: true

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      o = self.first_or_initialize(name: column)
      o.value = args.first
      o.save
    else
      o = self.first_or_initialize(name: method.to_s)
      o.value
    end
  end
end
