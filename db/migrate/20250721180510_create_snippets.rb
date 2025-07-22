class CreateSnippets < ActiveRecord::Migration[8.0]
  def change
    create_table :snippets do |t|
      t.string :name
      t.text :body
      t.string :filter

      t.timestamps
    end
    add_index :snippets, :name, unique: true
  end
end
