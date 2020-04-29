# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :entry_id
      t.integer :status
      t.string  :name,     limit: 50
      t.string  :email,    limit: 40
      t.string  :homepage, limit: 50
      t.text    :body

      t.timestamps
    end
  end
end
