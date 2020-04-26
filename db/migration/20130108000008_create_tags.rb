# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[4.2]
  def change
    unless table_exists?(:tags)
      create_table :tags do |t|
        t.string :name, null: false

        t.timestamps
      end
    end

    if table_exists?(:taggings)
      change_table :taggings do |t|
        t.remove :tag_context
      end
    else
      create_table :taggings do |t|
        t.integer :tag_id,        null: false
        t.string  :taggable_type, null: false
        t.integer :taggable_id,   null: false
      end
    end
  end
end
