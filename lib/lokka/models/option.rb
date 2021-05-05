# frozen_string_literal: true

class Option < ActiveRecord::Base
  validates :name,
            presence: true,
            uniqueness: true

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      option = where(name: column).first_or_create
      option.value = args.first.to_s
      option.save
    else
      option = where(name: attribute).first_or_initialize
      option.value
    end
  end
end
