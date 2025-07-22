class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.string :slug
      t.string :title, null: false
      t.text :body
      t.string :markup, default: 'html'
      t.string :type, null: false
      t.boolean :draft, default: false, null: false

      t.timestamps
    end
    add_index :entries, :slug, unique: true
  end
end
