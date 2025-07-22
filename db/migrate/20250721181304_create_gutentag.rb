class CreateGutentag < ActiveRecord::Migration[8.0]
  def change
    create_table :gutentag_tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    
    create_table :gutentag_taggings do |t|
      t.references :tag, null: false, foreign_key: { to_table: :gutentag_tags }
      t.references :taggable, null: false, polymorphic: true
      t.timestamps
    end
    
    add_index :gutentag_tags, :name, unique: true
    add_index :gutentag_taggings, [:taggable_type, :taggable_id]
    add_index :gutentag_taggings, [:tag_id, :taggable_type, :taggable_id], unique: true, name: 'unique_taggings'
  end
end
