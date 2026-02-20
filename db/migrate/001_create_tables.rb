class CreateTables < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :title, limit: 255
      t.string :description, limit: 255
      t.text :dashboard
      t.string :theme, limit: 64
      t.string :mobile_theme, limit: 64
      t.integer :per_page
      t.string :default_sort, limit: 255
      t.string :default_order, limit: 255
      t.string :default_markup, limit: 255
      t.string :meta_description, limit: 255
      t.string :meta_keywords, limit: 255
      t.timestamps
    end

    create_table :options, id: false do |t|
      t.string :name, limit: 255, null: false
      t.text :value
      t.timestamps
    end
    add_index :options, :name, unique: true

    create_table :users do |t|
      t.string :name, limit: 40
      t.string :email, limit: 40
      t.string :hashed_password
      t.string :salt
      t.integer :permission_level, default: 1
      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true

    create_table :entries do |t|
      t.integer :user_id
      t.integer :category_id
      t.string :slug, limit: 255
      t.string :title, limit: 255
      t.text :body
      t.string :markup, limit: 255
      t.string :type
      t.boolean :draft, default: false
      t.timestamps
    end
    add_index :entries, :slug, unique: true
    add_index :entries, :user_id
    add_index :entries, :category_id
    add_index :entries, :type

    create_table :categories do |t|
      t.string :slug, limit: 255
      t.string :title, limit: 255
      t.text :description
      t.string :type
      t.integer :parent_id
      t.timestamps
    end
    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id

    create_table :comments do |t|
      t.integer :entry_id
      t.integer :status
      t.string :name
      t.string :email, limit: 40
      t.string :homepage
      t.text :body
      t.timestamps
    end
    add_index :comments, :entry_id

    create_table :snippets do |t|
      t.string :name, limit: 255
      t.text :body
      t.timestamps
    end
    add_index :snippets, :name, unique: true

    create_table :tags do |t|
      t.string :name, limit: 255
      t.timestamps null: true
    end
    add_index :tags, :name, unique: true

    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string :taggable_type
      t.string :tag_context
      t.timestamps null: true
    end
    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, :tag_id

    create_table :field_names do |t|
      t.string :name, limit: 255
      t.timestamps
    end
    add_index :field_names, :name, unique: true

    create_table :fields do |t|
      t.integer :field_name_id
      t.integer :entry_id
      t.text :value
      t.timestamps
    end
    add_index :fields, [:entry_id, :field_name_id]
  end
end
