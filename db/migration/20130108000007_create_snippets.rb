# frozen_string_literal: true

class CreateSnippets < ActiveRecord::Migration[4.2]
  def change
    return if table_exists? :snippets

    create_table :snippets do |t|
      t.string  :name, limit: 255
      t.text    :body

      t.timestamps
    end
  end
end
