# frozen_string_literal: true

class CreateFields < ActiveRecord::Migration[4.2]
  def change
    create_table :fields do |t|
      t.integer :field_name_id
      t.integer :entry_id
      t.text    :value

      t.timestamps
    end
  end
end
