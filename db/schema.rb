# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130108000009) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "status"
    t.string   "name",       :limit => 50
    t.string   "email",      :limit => 40
    t.string   "homepage",   :limit => 50
    t.text     "body"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "slug"
    t.string   "title"
    t.text     "body"
    t.string   "markup"
    t.string   "type",                           :null => false
    t.boolean  "draft",       :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "field_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fields", :force => true do |t|
    t.integer  "field_name_id"
    t.integer  "entry_id"
    t.text     "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.text     "dashboard"
    t.string   "theme",            :limit => 64
    t.string   "mobile_theme",     :limit => 64
    t.integer  "per_page"
    t.string   "default_sort"
    t.string   "default_order"
    t.string   "default_markup"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "snippets", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id",        :null => false
    t.string  "taggable_type", :null => false
    t.integer "taggable_id",   :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",             :limit => 40
    t.string   "email",            :limit => 40
    t.string   "password_digest",  :limit => 60
    t.integer  "permission_level",               :default => 1
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

end
