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

ActiveRecord::Schema[8.1].define(version: 2026_03_18_150743) do
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
    t.float "absorption_rate"
    t.datetime "created_at", null: false
    t.float "half_life"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.float "volume_of_distribution"
    t.index ["name"], name: "index_active_ingredients_on_name", unique: true
  end

  create_table "active_ingredients_medications", id: false, force: :cascade do |t|
    t.integer "active_ingredient_id", null: false
    t.integer "medication_id", null: false
    t.index ["medication_id", "active_ingredient_id"], name: "idx_on_medication_id_active_ingredient_id_17a7d3821b"
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

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_medications", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "medication_id", null: false
    t.index ["medication_id", "category_id"], name: "index_categories_medications_on_medication_id_and_category_id"
  end

  create_table "doses", force: :cascade do |t|
    t.float "amount_taken", null: false
    t.datetime "created_at", null: false
    t.integer "prescription_id", null: false
    t.datetime "taken_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prescription_id"], name: "index_doses_on_prescription_id"
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

  create_table "medication_release_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "delay"
    t.integer "medication_id", null: false
    t.float "release_duration"
    t.integer "release_profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_medication_release_profiles_on_medication_id"
    t.index ["release_profile_id"], name: "index_medication_release_profiles_on_release_profile_id"
  end

  create_table "medication_version_ingredients", force: :cascade do |t|
    t.integer "active_ingredient_id", null: false
    t.float "amount"
    t.datetime "created_at", null: false
    t.integer "medication_version_id", null: false
    t.integer "unit"
    t.datetime "updated_at", null: false
    t.index ["active_ingredient_id"], name: "index_medication_version_ingredients_on_active_ingredient_id"
    t.index ["medication_version_id"], name: "index_medication_version_ingredients_on_medication_version_id"
  end

  create_table "medication_versions", force: :cascade do |t|
    t.string "added_name", null: false
    t.datetime "created_at", null: false
    t.integer "medication_id", null: false
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

  create_table "packs", force: :cascade do |t|
    t.date "acquired_at", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.integer "prescription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["prescription_id"], name: "index_packs_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.float "amount"
    t.datetime "created_at", null: false
    t.integer "medication_version_id", null: false
    t.boolean "pack_tracking_enabled", default: true, null: false
    t.float "preview_future", default: 40.0, null: false
    t.float "preview_past", default: 24.0, null: false
    t.text "routine"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["medication_version_id"], name: "index_prescriptions_on_medication_version_id"
    t.index ["user_id"], name: "index_prescriptions_on_user_id"
  end

  create_table "release_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_release_profiles_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "language", default: "en", null: false
    t.string "password_digest", null: false
    t.integer "pfp", default: 0, null: false
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "doses", "prescriptions"
  add_foreign_key "medication_release_profiles", "medications"
  add_foreign_key "medication_release_profiles", "release_profiles"
  add_foreign_key "medication_version_ingredients", "active_ingredients"
  add_foreign_key "medication_version_ingredients", "medication_versions"
  add_foreign_key "medication_versions", "medications"
  add_foreign_key "medications", "forms"
  add_foreign_key "medications", "labelers"
  add_foreign_key "packs", "prescriptions"
  add_foreign_key "prescriptions", "medication_versions"
  add_foreign_key "prescriptions", "users"
  add_foreign_key "sessions", "users"
end
