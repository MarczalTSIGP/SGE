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

ActiveRecord::Schema.define(version: 2018_09_19_154437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "department_roles", force: :cascade do |t|
    t.bigint "department_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_roles_on_department_id"
    t.index ["role_id"], name: "index_department_roles_on_role_id"
    t.index ["user_id"], name: "index_department_roles_on_user_id"
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

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "department_roles", "departments"
  add_foreign_key "department_roles", "roles"
  add_foreign_key "department_roles", "users"
end
