# frozen_string_literal: true

class FieldName < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validate :validate_if_entry_respond_to

  def self.get(id)
    find_by(id: id)
  end

  private

  def validate_if_entry_respond_to
    entry = Entry.new
    return unless entry.respond_to?(name, true)
    errors.add(:name, "'#{name}' cannot be used because Entry has a method of the same name")
  end
end

def FieldName(id)
  FieldName.get(id)
end
