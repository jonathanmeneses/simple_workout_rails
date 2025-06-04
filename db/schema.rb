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

ActiveRecord::Schema[8.0].define(version: 2025_06_04_144859) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exercise_equipments", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "equipment_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_exercise_equipments_on_equipment_id"
    t.index ["exercise_id", "equipment_id"], name: "index_exercise_equipments_on_exercise_id_and_equipment_id", unique: true
    t.index ["exercise_id"], name: "index_exercise_equipments_on_exercise_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.bigint "movement_pattern_id", null: false
    t.integer "exercise_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.text "notes"
    t.text "benefits"
    t.string "category"
    t.index ["movement_pattern_id"], name: "index_exercises_on_movement_pattern_id"
  end

  create_table "movement_patterns", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workout_cycles", force: :cascade do |t|
    t.string "name"
    t.integer "cycle_type"
    t.bigint "workout_program_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["workout_program_id"], name: "index_workout_cycles_on_workout_program_id"
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.bigint "workout_session_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "sets"
    t.integer "reps"
    t.string "notes"
    t.integer "order_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exercise_type"
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_session_id"], name: "index_workout_exercises_on_workout_session_id"
  end

  create_table "workout_programs", force: :cascade do |t|
    t.string "name"
    t.integer "program_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_workout_programs_on_user_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.string "name"
    t.bigint "workout_cycle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_cycle_id"], name: "index_workout_sessions_on_workout_cycle_id"
  end

  create_table "workout_sets", force: :cascade do |t|
    t.bigint "workout_exercise_id", null: false
    t.integer "order", null: false
    t.string "target_reps", null: false
    t.string "target_weight"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_exercise_id"], name: "index_workout_sets_on_workout_exercise_id"
  end

  add_foreign_key "exercise_equipments", "equipment"
  add_foreign_key "exercise_equipments", "exercises"
  add_foreign_key "exercises", "movement_patterns"
  add_foreign_key "sessions", "users"
  add_foreign_key "workout_cycles", "workout_programs"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workout_sessions"
  add_foreign_key "workout_programs", "users"
  add_foreign_key "workout_sessions", "workout_cycles"
  add_foreign_key "workout_sets", "workout_exercises"
end
