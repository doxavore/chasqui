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

ActiveRecord::Schema.define(version: 2020_05_21_121454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "line_1"
    t.string "line_2"
    t.string "locality"
    t.string "administrative_area"
    t.string "postal_code"
    t.string "country"
    t.string "lat"
    t.string "lon"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "collection_points", force: :cascade do |t|
    t.string "name"
    t.bigint "coordinator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coordinator_id"], name: "index_collection_points_on_coordinator_id"
  end

  create_table "external_entities", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_external_entities_on_user_id"
  end

  create_table "inventory_lines", force: :cascade do |t|
    t.string "inventoried_type", null: false
    t.bigint "inventoried_id", null: false
    t.integer "quantity_present", default: 0, null: false
    t.integer "quantity_desired", default: 0, null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventoried_type", "inventoried_id"], name: "index_inventory_lines_on_inventoried_type_and_inventoried_id"
    t.index ["product_id"], name: "index_inventory_lines_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "external_entity_id", null: false
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "collection_point_id"
    t.string "legacy_order_number"
    t.index ["collection_point_id"], name: "index_orders_on_collection_point_id"
    t.index ["external_entity_id"], name: "index_orders_on_external_entity_id"
  end

  create_table "printer_models", force: :cascade do |t|
    t.string "name"
    t.integer "x_mm"
    t.integer "y_mm"
    t.integer "z_mm"
    t.boolean "petg"
    t.boolean "abs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "printers", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.bigint "printer_model_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["printer_model_id"], name: "index_printers_on_printer_model_id"
    t.index ["user_id"], name: "index_printers_on_user_id"
  end

  create_table "product_assignments", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "assigned_type", null: false
    t.bigint "assigned_id", null: false
    t.index ["assigned_type", "assigned_id", "product_id"], name: "idx_pa_at_ai_pi", unique: true
    t.index ["assigned_type", "assigned_id"], name: "index_product_assignments_on_assigned_type_and_assigned_id"
    t.index ["product_id"], name: "index_product_assignments_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "producible"
  end

  create_table "receipts", force: :cascade do |t|
    t.string "origin_type", null: false
    t.bigint "origin_id", null: false
    t.string "destination_type", null: false
    t.bigint "destination_id", null: false
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_type", "destination_id"], name: "index_receipts_on_destination_type_and_destination_id"
    t.index ["origin_type", "origin_id"], name: "index_receipts_on_origin_type_and_origin_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "coordinator_id"
    t.boolean "admin"
    t.string "phone"
    t.string "company"
    t.string "first_name"
    t.string "last_name"
    t.string "profession"
    t.string "status"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["coordinator_id"], name: "index_users_on_coordinator_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collection_points", "users", column: "coordinator_id"
  add_foreign_key "orders", "collection_points"
  add_foreign_key "users", "users", column: "coordinator_id"
end
