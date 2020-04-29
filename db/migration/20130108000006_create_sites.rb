# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[4.2]
  def change
    create_table :sites do |t|
      t.string  :title,            limit: 255
      t.string  :description,      limit: 255
      t.text    :dashboard
      t.string  :theme,            limit: 64
      t.string  :mobile_theme,     limit: 64
      t.integer :per_page
      t.string  :default_sort,     limit: 255
      t.string  :default_order,    limit: 255
      t.string  :default_markup,   limit: 255
      t.string  :meta_description, limit: 255
      t.string  :meta_keywords,    limit: 255

      t.timestamps
    end
  end
end
