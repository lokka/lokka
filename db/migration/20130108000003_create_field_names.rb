class CreateFieldNames < ActiveRecord::Migration[4.2]
  def change
    create_table :field_names do |t|
      t.string  :name, limit: 255

      t.timestamps
    end
  end
end
