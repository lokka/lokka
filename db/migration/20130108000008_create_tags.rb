class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string  :name, null: false

      t.timestamps
    end

    create_table :taggings do |t|
      t.integer :tag_id,        null: false
      t.string  :taggable_type, null: false
      t.integer :taggable_id,   null: false
    end
  end
end
