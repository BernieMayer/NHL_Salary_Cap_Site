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

ActiveRecord::Schema[7.1].define(version: 2024_08_03_191445) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cap_hits", force: :cascade do |t|
    t.decimal "cap_value", precision: 12, scale: 2
    t.bigint "team_id"
    t.bigint "player_id"
    t.bigint "year"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "cap_type", default: "Roster"
    t.index ["player_id"], name: "idx_16946_index_cap_hits_on_player_id"
    t.index ["team_id"], name: "idx_16946_index_cap_hits_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.text "name"
    t.bigint "team_id"
    t.text "position"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "status", default: "Roster"
    t.index ["team_id"], name: "idx_16931_index_players_on_team_id"
  end

  create_table "salary_cap_totals", force: :cascade do |t|
    t.bigint "team_id"
    t.decimal "total"
    t.bigint "year"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.index ["team_id"], name: "idx_16939_index_salary_cap_totals_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.text "name"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "code"
  end

  add_foreign_key "cap_hits", "players", name: "cap_hits_player_id_fkey"
  add_foreign_key "cap_hits", "teams", name: "cap_hits_team_id_fkey"
  add_foreign_key "players", "teams", name: "players_team_id_fkey"
  add_foreign_key "salary_cap_totals", "teams", name: "salary_cap_totals_team_id_fkey"
end
