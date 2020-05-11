# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    return if table_exists? :categories

    create_table :categories do |t|
      t.string  :title,       limit: 255
      t.string  :slug,        limit: 255
      t.text    :description
      t.integer :parent_id

      t.timestamps
    end
  end
end
