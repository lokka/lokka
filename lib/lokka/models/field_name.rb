# frozen_string_literal: true

class FieldName < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true,
                   uniqueness: true
  validate :validate_if_entry_respond_to

  def validate_if_entry_respond_to
    entry = Entry.new
    return true unless entry.respond_to?(name, true)
    [false, "'#{name}' cannot be used because Entry has a method of the same name"]
  end
end
