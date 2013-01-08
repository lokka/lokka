class CreateFieldNames < ActiveRecord::Migration
  def change
    create_table :field_names do |t|
      t.integer :id
      t.string  :name, limit: 255

      t.timestamps
    end
  end
end
