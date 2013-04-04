class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :id
      t.string  :title,       limit: 255
      t.string  :slug,        limit: 255
      t.text    :description
      t.integer :parent_id

      t.timestamps
    end
  end
end
