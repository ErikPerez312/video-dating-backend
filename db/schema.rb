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

ActiveRecord::Schema.define(version: 20180520193243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_men", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_available_men_on_user_id"
  end

  create_table "available_women", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_available_women_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "cantor_identifier"
    t.boolean "is_match", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cantor_identifier"], name: "index_matches_on_cantor_identifier", unique: true
  end

  create_table "matches_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "match_id", null: false
  end

  create_table "profile_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "image_file_file_name"
    t.string "image_file_content_type"
    t.integer "image_file_file_size"
    t.datetime "image_file_updated_at"
    t.index ["user_id"], name: "index_profile_images_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age"
    t.string "token"
    t.string "password_hash"
    t.string "password_salt"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_online", default: false
    t.boolean "is_available", default: false
    t.integer "seeking"
    t.integer "gender"
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "available_men", "users"
  add_foreign_key "available_women", "users"
  add_foreign_key "profile_images", "users"
end
