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

ActiveRecord::Schema[8.1].define(version: 2026_02_21_200835) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_active_ingredients_on_name", unique: true
  end

  create_table "active_ingredients_medications", id: false, force: :cascade do |t|
    t.integer "active_ingredient_id", null: false
    t.integer "medication_id", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assistent_talks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "talk", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_assistent_talks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_medications", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "medication_id", null: false
  end

  create_table "doses", force: :cascade do |t|
    t.float "amount_taken", null: false
    t.datetime "created_at", null: false
    t.integer "pack_id", null: false
    t.datetime "taken_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pack_id"], name: "index_doses_on_pack_id"
  end

  create_table "forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_forms_on_name", unique: true
  end

  create_table "labelers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_labelers_on_name", unique: true
  end

  create_table "medication_versions", force: :cascade do |t|
    t.string "added_name", null: false
    t.datetime "created_at", null: false
    t.integer "medication_id", null: false
    t.string "ndc", null: false
    t.integer "strength_per_dose"
    t.integer "unit", default: 0
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_medication_versions_on_medication_id"
  end

  create_table "medications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "form_id", null: false
    t.integer "labeler_id"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_medications_on_form_id"
    t.index ["labeler_id"], name: "index_medications_on_labeler_id"
  end

  create_table "medications_references", id: false, force: :cascade do |t|
    t.integer "medication_id", null: false
    t.integer "reference_id", null: false
  end

  create_table "packs", force: :cascade do |t|
    t.integer "amount", null: false
    t.date "aquired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_medication_id", null: false
    t.index ["user_medication_id"], name: "index_packs_on_user_medication_id"
  end

  create_table "references", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["name"], name: "index_references_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_medications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dosage", null: false
    t.integer "medication_version_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["medication_version_id"], name: "index_user_medications_on_medication_version_id"
    t.index ["user_id"], name: "index_user_medications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assistent_talks", "users"
  add_foreign_key "doses", "packs"
  add_foreign_key "medication_versions", "medications"
  add_foreign_key "medications", "forms"
  add_foreign_key "medications", "labelers"
  add_foreign_key "packs", "user_medications"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_medications", "medication_versions"
  add_foreign_key "user_medications", "users"
end
