class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.integer :id
      t.string  :name, limit: 255
      t.text    :body

      t.timestamps
    end
  end
end
