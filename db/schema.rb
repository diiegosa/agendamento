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

ActiveRecord::Schema.define(version: 20190313173610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_modules", force: :cascade do |t|
    t.string "module"
    t.string "controller"
    t.json "actions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "service_point_id"
    t.bigint "service_id"
    t.date "date"
    t.integer "shift"
    t.integer "attendant_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_availabilities_on_service_id"
    t.index ["service_point_id"], name: "index_availabilities_on_service_point_id"
  end

  create_table "expert_availabilities", force: :cascade do |t|
    t.bigint "expert_id"
    t.integer "shift"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expert_id"], name: "index_expert_availabilities_on_expert_id"
  end

  create_table "experts", force: :cascade do |t|
    t.string "name"
    t.bigint "service_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_point_id"], name: "index_experts_on_service_point_id"
  end

  create_table "experts_services", id: false, force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "expert_id", null: false
  end

  create_table "permissions", id: false, force: :cascade do |t|
    t.bigint "profile_id"
    t.bigint "app_module_id"
    t.json "actions"
    t.index ["app_module_id"], name: "index_permissions_on_app_module_id"
    t.index ["profile_id", "app_module_id"], name: "index_permissions_on_profile_id_and_app_module_id", unique: true
    t.index ["profile_id"], name: "index_permissions_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "client_name"
    t.string "client_cpf"
    t.string "client_email"
    t.string "client_cellphone_number"
    t.string "property_sequential_or_protocol"
    t.date "date"
    t.time "time"
    t.text "description"
    t.string "schedule_protocol"
    t.bigint "service_id"
    t.bigint "service_point_id"
    t.string "avaliable_type"
    t.bigint "avaliable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sga_token_number"
    t.string "sga_token_initials"
    t.string "sga_status"
    t.index ["avaliable_type", "avaliable_id"], name: "index_schedules_on_avaliable_type_and_avaliable_id"
    t.index ["service_id"], name: "index_schedules_on_service_id"
    t.index ["service_point_id"], name: "index_schedules_on_service_point_id"
  end

  create_table "service_points", force: :cascade do |t|
    t.integer "novo_sga_service_point_id"
    t.string "city"
    t.string "neighborhood"
    t.string "public_area"
    t.string "cep"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["novo_sga_service_point_id"], name: "index_service_points_on_novo_sga_service_point_id", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.integer "novo_sga_service_id"
    t.text "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fa_icon"
    t.index ["novo_sga_service_id"], name: "index_services_on_novo_sga_service_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "service_points"
  add_foreign_key "availabilities", "services"
  add_foreign_key "expert_availabilities", "experts"
  add_foreign_key "experts", "service_points"
  add_foreign_key "permissions", "app_modules"
  add_foreign_key "permissions", "profiles"
  add_foreign_key "schedules", "service_points"
  add_foreign_key "schedules", "services"
  add_foreign_key "users", "profiles"
end
