class FieldName < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true,
                   uniqueness: true
  validate :validate_if_entry_respond_to

  def validate_if_entry_respond_to
    entry = Entry.new
    if entry.respond_to?(self.name, true)
      [false, "'#{self.name}' cannot be used because Entry has a method of the same name"]
    else
      return true
    end
  end
end
