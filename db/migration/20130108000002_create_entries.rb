class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :id
      t.integer :user_id
      t.integer :category_id
      t.string  :slug,        limit: 255, unique: true
      t.string  :title,       limit: 255
      t.text    :body
      t.string  :markup,      limit: 255
      t.string  :type,        null: false
      t.boolean :draft,       default: false

      t.timestamps
    end
  end
end
