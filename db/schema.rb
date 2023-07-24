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

ActiveRecord::Schema[7.0].define(version: 2023_07_23_213745) do
  # These are extensions that must be enabled in order to support this database
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

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "summary"
    t.datetime "published_at"
    t.string "nostr_identifier"
    t.string "replicate_identifier"
    t.json "replicate_raw_response_body", default: {}, null: false
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "prompt"
    t.json "chat_raw_response_body", default: {}, null: false
    t.json "replicate_raw_request_body", default: {}, null: false
    t.index ["nostr_identifier"], name: "index_chapters_on_nostr_identifier", unique: true
    t.index ["replicate_identifier"], name: "index_chapters_on_replicate_identifier", unique: true
    t.index ["story_id"], name: "index_chapters_on_story_id"
  end

  create_table "nostr_users", force: :cascade do |t|
    t.string "name"
    t.string "public_key"
    t.string "private_key"
    t.string "relay_url"
    t.integer "language", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["private_key"], name: "index_nostr_users_on_private_key", unique: true
    t.index ["public_key"], name: "index_nostr_users_on_public_key", unique: true
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.integer "chapters_count", default: 0, null: false
    t.datetime "adventure_ended_at"
    t.json "raw_response_body", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mode", default: 0, null: false
    t.string "replicate_identifier"
    t.json "replicate_raw_request_body", default: {}, null: false
    t.json "replicate_raw_response_body", default: {}, null: false
    t.integer "language", default: 0, null: false
    t.index ["replicate_identifier"], name: "index_stories_on_replicate_identifier", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chapters", "stories"
end
