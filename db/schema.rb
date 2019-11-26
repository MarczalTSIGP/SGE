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

ActiveRecord::Schema.define(version: 2019_11_22_170003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

# Could not dump table "clients" because of following StandardError
#   Unknown type 'client_kinds' for column 'kind'

  create_table "department_users", force: :cascade do |t|
    t.bigint "department_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_users_on_department_id"
    t.index ["role_id"], name: "index_department_users_on_role_id"
    t.index ["user_id"], name: "index_department_users_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "local"
    t.string "phone"
    t.string "initials"
    t.string "email"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "division_users", force: :cascade do |t|
    t.bigint "division_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_division_users_on_division_id"
    t.index ["role_id"], name: "index_division_users_on_role_id"
    t.index ["user_id"], name: "index_division_users_on_user_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_clients", force: :cascade do |t|
    t.bigint "document_id"
    t.json "information", default: {}, null: false
    t.string "cpf"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key_code"
    t.index ["document_id"], name: "index_document_clients_on_document_id"
    t.index ["key_code"], name: "index_document_clients_on_key_code", unique: true
  end

  create_table "document_users", force: :cascade do |t|
    t.bigint "document_id"
    t.bigint "user_id"
    t.string "function"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "subscription", default: false
    t.datetime "signature_datetime"
    t.index ["document_id", "user_id"], name: "index_document_users_on_document_id_and_user_id", unique: true
    t.index ["document_id"], name: "index_document_users_on_document_id"
    t.index ["user_id"], name: "index_document_users_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "front"
    t.text "back"
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "variables", default: {}, null: false
    t.boolean "request_signature", default: false
    t.index ["division_id"], name: "index_documents_on_division_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "department", default: false
    t.index ["identifier"], name: "index_roles_on_identifier"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "name"
    t.boolean "active", default: true
    t.integer "registration_number"
    t.string "cpf"
    t.boolean "admin", default: false
    t.boolean "support", default: false
    t.string "alternative_email"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_number"], name: "index_users_on_registration_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "document_clients", "documents"
  add_foreign_key "document_users", "documents"
  add_foreign_key "document_users", "users"
  add_foreign_key "documents", "divisions"
end
