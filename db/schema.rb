# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_29_105210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "body"
    t.string "ip_address"
    t.string "user_agent"
    t.string "referrer"
    t.bigint "site_id", null: false
    t.bigint "discussion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_comments_on_discussion_id"
    t.index ["site_id"], name: "index_comments_on_site_id"
  end

  create_table "discussions", force: :cascade do |t|
    t.string "url"
    t.integer "comments_count", default: 0
    t.integer "likes", default: 0
    t.bigint "site_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id", "url"], name: "index_discussions_on_site_id_and_url", unique: true
    t.index ["site_id"], name: "index_discussions_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "domain"
    t.integer "discussions_count", default: 0
    t.integer "comments_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain"], name: "index_sites_on_domain", unique: true
  end

  add_foreign_key "comments", "discussions"
  add_foreign_key "comments", "sites"
  add_foreign_key "discussions", "sites"
end
