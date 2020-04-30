class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :id
      t.integer :field_name_id
      t.integer :entry_id
      t.text    :value

      t.timestamps
    end
  end
end
