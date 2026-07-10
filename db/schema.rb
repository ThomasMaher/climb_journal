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

ActiveRecord::Schema[8.0].define(version: 2026_07_09_231031) do
  create_table "boulders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "vgrade_range_min", null: false
    t.integer "vgrade_range_max"
    t.integer "self_grade"
    t.integer "incline"
    t.integer "rating"
    t.text "notes"
    t.boolean "indoor", default: false
    t.boolean "outdoor", default: false
    t.boolean "kilter_board", default: false
    t.string "nickname", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incline"], name: "index_boulders_on_incline"
    t.index ["indoor"], name: "index_boulders_on_indoor"
    t.index ["kilter_board"], name: "index_boulders_on_kilter_board"
    t.index ["nickname"], name: "index_boulders_on_nickname"
    t.index ["outdoor"], name: "index_boulders_on_outdoor"
    t.index ["rating"], name: "index_boulders_on_rating"
    t.index ["self_grade"], name: "index_boulders_on_self_grade"
    t.index ["vgrade_range_max"], name: "index_boulders_on_vgrade_range_max"
    t.index ["vgrade_range_min"], name: "index_boulders_on_vgrade_range_min"
  end

  create_table "session_boulders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "session_id", null: false
    t.integer "boulder_id", null: false
    t.integer "attempts"
    t.integer "percent_finished", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attempts"], name: "index_session_boulders_on_attempts"
    t.index ["boulder_id"], name: "index_session_boulders_on_boulder_id"
    t.index ["percent_finished"], name: "index_session_boulders_on_percent_finished"
    t.index ["session_id", "boulder_id"], name: "index_session_boulders_on_session_id_and_boulder_id", unique: true
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date", null: false
    t.string "gym_name", limit: 50, null: false
    t.text "notes", size: :tiny
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_sessions_on_date"
    t.index ["gym_name"], name: "index_sessions_on_gym_name"
  end
end
