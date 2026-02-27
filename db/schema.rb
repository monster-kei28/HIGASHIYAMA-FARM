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

ActiveRecord::Schema[7.2].define(version: 2026_02_27_143634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["uid"], name: "index_admins_on_uid", unique: true
    t.index ["user_id"], name: "index_admins_on_user_id_unique", unique: true
  end

  create_table "calendar_events", force: :cascade do |t|
    t.date "event_date", null: false
    t.integer "kind", default: 0, null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_calendar_events_on_event_date", unique: true
  end

  create_table "harvest_experiences", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "harvest_experience_id", null: false
    t.integer "number_of_people"
    t.string "status"
    t.datetime "reserved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["harvest_experience_id"], name: "index_reservations_on_harvest_experience_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "admins", "users"
  add_foreign_key "reservations", "harvest_experiences"
  add_foreign_key "reservations", "users"
end
