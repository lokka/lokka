class Field < ActiveRecord::Base
  belongs_to :field_name
  belongs_to :entry
end
