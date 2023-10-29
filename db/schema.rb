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

ActiveRecord::Schema[7.1].define(version: 2023_10_29_190750) do
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
    t.integer "position", default: 1, null: false
    t.boolean "publish", default: false, null: false
    t.integer "status", default: 0, null: false
    t.integer "most_voted_option_index"
    t.index ["nostr_identifier"], name: "index_chapters_on_nostr_identifier", unique: true
    t.index ["replicate_identifier"], name: "index_chapters_on_replicate_identifier", unique: true
    t.index ["story_id"], name: "index_chapters_on_story_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "biography"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_characters_on_first_name_and_last_name", unique: true
  end

  create_table "characters_stories", id: false, force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "story_id", null: false
    t.index ["character_id", "story_id"], name: "index_characters_stories_on_character_id_and_story_id", unique: true
    t.index ["character_id"], name: "index_characters_stories_on_character_id"
    t.index ["story_id"], name: "index_characters_stories_on_story_id"
  end

  create_table "nostr_users", force: :cascade do |t|
    t.string "private_key"
    t.string "language", limit: 2, default: "EN", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stories_count", default: 0, null: false
    t.boolean "enabled", default: true, null: false
    t.json "metadata_response", default: {}, null: false
    t.integer "mode", default: 0, null: false
    t.string "name"
    t.text "about"
    t.string "nip05"
    t.string "website"
    t.string "lud16"
    t.string "display_name"
    t.index ["private_key"], name: "index_nostr_users_on_private_key", unique: true
  end

  create_table "nostr_users_relays", id: false, force: :cascade do |t|
    t.bigint "nostr_user_id", null: false
    t.bigint "relay_id", null: false
    t.index ["nostr_user_id", "relay_id"], name: "index_nostr_users_relays_on_nostr_user_id_and_relay_id", unique: true
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places_stories", id: false, force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "story_id", null: false
    t.index ["place_id"], name: "index_places_stories_on_place_id"
    t.index ["story_id"], name: "index_places_stories_on_story_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.string "type"
    t.string "title"
    t.text "body"
    t.text "negative_body"
    t.jsonb "options", default: {}, null: false
    t.integer "stories_count", default: 0, null: false
    t.boolean "enabled", default: true, null: false
    t.integer "position", default: 1, null: false
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relays", force: :cascade do |t|
    t.string "url"
    t.text "description"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
    t.index ["url"], name: "index_relays_on_url", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.jsonb "chapter_options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "thematic_id"
    t.boolean "enabled", default: true, null: false
    t.string "nostr_identifier"
    t.bigint "nostr_user_id"
    t.string "summary"
    t.string "back_cover_nostr_identifier"
    t.integer "publication_rule", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.jsonb "options", default: {}, null: false
    t.bigint "media_prompt_id"
    t.bigint "narrator_prompt_id"
    t.bigint "atmosphere_prompt_id"
    t.index ["atmosphere_prompt_id"], name: "index_stories_on_atmosphere_prompt_id"
    t.index ["back_cover_nostr_identifier"], name: "index_stories_on_back_cover_nostr_identifier", unique: true
    t.index ["media_prompt_id"], name: "index_stories_on_media_prompt_id"
    t.index ["narrator_prompt_id"], name: "index_stories_on_narrator_prompt_id"
    t.index ["nostr_identifier"], name: "index_stories_on_nostr_identifier", unique: true
    t.index ["nostr_user_id"], name: "index_stories_on_nostr_user_id"
    t.index ["replicate_identifier"], name: "index_stories_on_replicate_identifier", unique: true
    t.index ["thematic_id"], name: "index_stories_on_thematic_id"
  end

  create_table "thematics", force: :cascade do |t|
    t.string "identifier"
    t.string "name_fr"
    t.string "name_en"
    t.text "description_fr"
    t.text "description_en"
    t.integer "stories_count", default: 0, null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_thematics_on_identifier", unique: true
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
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chapters", "stories"
  add_foreign_key "stories", "nostr_users"
  add_foreign_key "stories", "prompts", column: "atmosphere_prompt_id"
  add_foreign_key "stories", "prompts", column: "media_prompt_id"
  add_foreign_key "stories", "prompts", column: "narrator_prompt_id"
  add_foreign_key "stories", "thematics"
end
