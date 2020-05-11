# frozen_string_literal: true

class CreateOptions < ActiveRecord::Migration[4.2]
  def change
    return if table_exists? :options

    create_table :options do |t|
      t.string  :name, unique: true, limit: 255, null: false
      t.text    :value

      t.timestamps
    end
  end
end
