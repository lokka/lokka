class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :entry, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :url
      t.text :body, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
