# frozen_string_literal: true

class Option < ActiveRecord::Base
  attr_accessible :name, :value

  validates :name,
    presence:   true,
    uniqueness: true

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      option = self.where(name: column).first_or_create
      option.value = args.first.to_s
      option.save
    else
      option = self.where(name: attribute).first_or_create
      option.value
    end
  end
end
