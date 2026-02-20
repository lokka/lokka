# frozen_string_literal: true

class Option < ActiveRecord::Base
  self.primary_key = 'name'

  validates :name, presence: true

  def self.method_missing(method, *args)
    attribute = method.to_s
    if attribute =~ /=$/
      column = attribute[0, attribute.size - 1]
      option = find_or_initialize_by(name: column)
      option.value = args.first.to_s
      option.save
    else
      option = find_or_initialize_by(name: method.to_s)
      option.value
    end
  end

  def self.respond_to_missing?(_method, _include_private = false)
    true
  end
end
