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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2013_01_08_000009) do

  create_table "categories", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "entry_id"
    t.integer "status"
    t.string "name", limit: 50
    t.string "email", limit: 40
    t.string "homepage", limit: 50
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.string "slug", limit: 255
    t.string "title", limit: 255
    t.text "body"
    t.string "markup", limit: 255
    t.string "type", null: false
    t.boolean "draft", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_names", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", force: :cascade do |t|
    t.integer "field_name_id"
    t.integer "entry_id"
    t.text "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "description", limit: 255
    t.text "dashboard"
    t.string "theme", limit: 64
    t.string "mobile_theme", limit: 64
    t.integer "per_page"
    t.string "default_sort", limit: 255
    t.string "default_order", limit: 255
    t.string "default_markup", limit: 255
    t.string "meta_description", limit: 255
    t.string "meta_keywords", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 40
    t.string "email", limit: 40
    t.string "password_digest", limit: 60
    t.integer "permission_level", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
