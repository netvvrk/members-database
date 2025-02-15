# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_15_031025) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "artworks", force: :cascade do |t|
    t.string "title", null: false
    t.string "material", null: false
    t.string "description"
    t.integer "price"
    t.boolean "visible"
    t.integer "duration"
    t.string "units", default: "in", null: false
    t.decimal "height"
    t.decimal "width"
    t.decimal "depth"
    t.string "location", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.string "edition", default: "", null: false
    t.boolean "active", default: true, null: false
    t.integer "position", null: false
    t.string "medium"
    t.decimal "non_search_rank"
    t.index ["active"], name: "index_artworks_on_active"
    t.index ["user_id", "position"], name: "index_artworks_on_user_id_and_position", unique: true
    t.index ["user_id"], name: "index_artworks_on_user_id"
    t.index ["year"], name: "index_artworks_on_year"
  end

  create_table "chargebee_events", id: false, force: :cascade do |t|
    t.string "event_id", null: false
    t.datetime "created_at", null: false
    t.string "event_type", null: false
    t.string "user_email"
    t.jsonb "content"
    t.index ["content"], name: "chargebee_events_idx", using: :gin
    t.index ["created_at"], name: "index_chargebee_events_on_created_at"
    t.index ["event_id"], name: "index_chargebee_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_chargebee_events_on_event_type"
    t.index ["user_email"], name: "index_chargebee_events_on_user_email"
  end

  create_table "images", force: :cascade do |t|
    t.string "caption"
    t.bigint "artwork_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["artwork_id", "position"], name: "index_images_on_artwork_id_and_position", unique: true
    t.index ["artwork_id"], name: "index_images_on_artwork_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.text "bio"
    t.string "website"
    t.string "social_1"
    t.string "social_2"
    t.string "disciplines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.index ["name"], name: "index_profiles_on_name"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "profiles_tags", id: false, force: :cascade do |t|
    t.integer "profile_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_profiles_tags_on_profile_id"
    t.index ["tag_id"], name: "index_profiles_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "active", default: true, null: false
    t.string "cb_customer_id"
    t.datetime "welcome_email_sent_at"
    t.index ["active"], name: "index_users_on_active"
    t.index ["cb_customer_id"], name: "index_users_on_cb_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artworks", "users"
  add_foreign_key "images", "artworks"
end
