class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
    add_index :options, :name, unique: true
  end
end
