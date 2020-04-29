# frozen_string_literal: true

class Option < ActiveRecord::Base
  validates :name,
            presence: true,
            uniqueness: true

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      o = where(name: column).first_or_create
      o.value = args.first.to_s
      o.save
    else
      o = where(name: attribute).first_or_create
      o.value
    end
  end
end
