# frozen_string_literal: true

class CreateFieldNames < ActiveRecord::Migration[4.2]
  def change
    return if table_exists? :field_names

    create_table :field_names do |t|
      t.string :name, limit: 255

      t.timestamps
    end
  end
end
