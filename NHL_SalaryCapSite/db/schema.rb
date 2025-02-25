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

ActiveRecord::Schema[7.1].define(version: 2025_02_14_194608) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "buyouts", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.string "team_name"
    t.decimal "cost"
    t.decimal "earning"
    t.decimal "savings"
    t.decimal "cap_hit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.string "season"
    t.index ["contract_id"], name: "index_buyouts_on_contract_id"
    t.index ["team_id"], name: "index_buyouts_on_team_id"
  end

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

  create_table "contract_details", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.string "season"
    t.string "clause"
    t.decimal "cap_hit", precision: 15, scale: 2
    t.decimal "aav", precision: 15, scale: 2
    t.decimal "performance_bonuses", precision: 15, scale: 2
    t.decimal "signing_bonuses", precision: 15, scale: 2
    t.decimal "base_salary", precision: 15, scale: 2
    t.decimal "total_salary", precision: 15, scale: 2
    t.decimal "minors_salary", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_details_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.string "expiry_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_contracts_on_player_id"
  end

  create_table "draft_picks", force: :cascade do |t|
    t.integer "year"
    t.integer "round"
    t.bigint "original_team_id", null: false
    t.bigint "current_team_id", null: false
    t.boolean "isTradedAway"
    t.date "tradedDate"
    t.text "conditions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_team_id"], name: "index_draft_picks_on_current_team_id"
    t.index ["original_team_id"], name: "index_draft_picks_on_original_team_id"
  end

  create_table "motor_alert_locks", force: :cascade do |t|
    t.bigint "alert_id", null: false
    t.string "lock_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id", "lock_timestamp"], name: "index_motor_alert_locks_on_alert_id_and_lock_timestamp", unique: true
    t.index ["alert_id"], name: "index_motor_alert_locks_on_alert_id"
  end

  create_table "motor_alerts", force: :cascade do |t|
    t.bigint "query_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "to_emails", null: false
    t.boolean "is_enabled", default: true, null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_alerts_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["query_id"], name: "index_motor_alerts_on_query_id"
    t.index ["updated_at"], name: "index_motor_alerts_on_updated_at"
  end

  create_table "motor_api_configs", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.text "preferences", null: false
    t.text "credentials", null: false
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_api_configs_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "motor_audits", force: :cascade do |t|
    t.string "auditable_id"
    t.string "auditable_type"
    t.string "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.bigint "version", default: 0
    t.text "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "motor_auditable_associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "motor_auditable_index"
    t.index ["created_at"], name: "index_motor_audits_on_created_at"
    t.index ["request_uuid"], name: "index_motor_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "motor_auditable_user_index"
  end

  create_table "motor_configs", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_motor_configs_on_key", unique: true
    t.index ["updated_at"], name: "index_motor_configs_on_updated_at"
  end

  create_table "motor_dashboards", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "motor_dashboards_title_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_dashboards_on_updated_at"
  end

  create_table "motor_forms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "api_path", null: false
    t.string "http_method", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.string "api_config_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_forms_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_forms_on_updated_at"
  end

  create_table "motor_note_tag_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "note_id", null: false
    t.index ["note_id", "tag_id"], name: "motor_note_tags_note_id_tag_id_index", unique: true
    t.index ["tag_id"], name: "index_motor_note_tag_tags_on_tag_id"
  end

  create_table "motor_note_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_note_tags_name_unique_index", unique: true
  end

  create_table "motor_notes", force: :cascade do |t|
    t.text "body"
    t.bigint "author_id"
    t.string "author_type"
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "author_type"], name: "motor_notes_author_id_author_type_index"
    t.index ["record_id", "record_type"], name: "motor_notes_record_id_record_type_index"
  end

  create_table "motor_notifications", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "record_id"
    t.string "record_type"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "recipient_type"], name: "motor_notifications_recipient_id_recipient_type_index"
    t.index ["record_id", "record_type"], name: "motor_notifications_record_id_record_type_index"
  end

  create_table "motor_queries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "sql_body", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_queries_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_queries_on_updated_at"
  end

  create_table "motor_reminders", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "author_type", null: false
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "record_id"
    t.string "record_type"
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "author_type"], name: "motor_reminders_author_id_author_type_index"
    t.index ["recipient_id", "recipient_type"], name: "motor_reminders_recipient_id_recipient_type_index"
    t.index ["record_id", "record_type"], name: "motor_reminders_record_id_record_type_index"
    t.index ["scheduled_at"], name: "index_motor_reminders_on_scheduled_at"
  end

  create_table "motor_resources", force: :cascade do |t|
    t.string "name", null: false
    t.text "preferences", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_motor_resources_on_name", unique: true
    t.index ["updated_at"], name: "index_motor_resources_on_updated_at"
  end

  create_table "motor_taggable_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.index ["tag_id"], name: "index_motor_taggable_tags_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "motor_polymorphic_association_tag_index", unique: true
  end

  create_table "motor_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_tags_name_unique_index", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.text "name"
    t.bigint "team_id"
    t.text "position"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "status", default: "Roster"
    t.string "acquired"
    t.string "draft_details"
    t.date "born"
    t.text "terms_details"
    t.integer "career_games_played"
    t.integer "career_seasons_played"
    t.string "slug"
    t.string "image_url"
    t.index ["name"], name: "index_players_on_name"
    t.index ["slug"], name: "index_players_on_slug", unique: true
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

  create_table "salary_retentions", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "contract_id", null: false
    t.decimal "retained_cap_hit", precision: 12, scale: 2, null: false
    t.decimal "retention_percentage", precision: 5, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "season"
    t.index ["contract_id"], name: "index_salary_retentions_on_contract_id"
    t.index ["team_id"], name: "index_salary_retentions_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.text "name"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "code"
    t.string "gm"
    t.string "coach"
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  add_foreign_key "buyouts", "contracts"
  add_foreign_key "buyouts", "teams"
  add_foreign_key "cap_hits", "players", name: "cap_hits_player_id_fkey"
  add_foreign_key "cap_hits", "teams", name: "cap_hits_team_id_fkey"
  add_foreign_key "contract_details", "contracts"
  add_foreign_key "contracts", "players"
  add_foreign_key "draft_picks", "teams", column: "current_team_id"
  add_foreign_key "draft_picks", "teams", column: "original_team_id"
  add_foreign_key "motor_alert_locks", "motor_alerts", column: "alert_id"
  add_foreign_key "motor_alerts", "motor_queries", column: "query_id"
  add_foreign_key "motor_note_tag_tags", "motor_note_tags", column: "tag_id"
  add_foreign_key "motor_note_tag_tags", "motor_notes", column: "note_id"
  add_foreign_key "motor_taggable_tags", "motor_tags", column: "tag_id"
  add_foreign_key "players", "teams", name: "players_team_id_fkey"
  add_foreign_key "salary_cap_totals", "teams", name: "salary_cap_totals_team_id_fkey"
  add_foreign_key "salary_retentions", "contracts"
  add_foreign_key "salary_retentions", "teams"
end
