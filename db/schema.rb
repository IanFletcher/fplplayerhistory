# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140508074759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", force: true do |t|
    t.string   "name",             limit: 30
    t.integer  "predicted_finish", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_histories", force: true do |t|
    t.integer  "player_id"
    t.integer  "round",            limit: 2
    t.datetime "gamedate"
    t.string   "opponent",         limit: 30
    t.string   "venue",            limit: 1
    t.integer  "miniutes_played",  limit: 2
    t.integer  "goals_scored",     limit: 2
    t.integer  "assists",          limit: 2
    t.integer  "clean_sheets",     limit: 2
    t.integer  "goals_conceded",   limit: 2
    t.integer  "own_goals",        limit: 2
    t.integer  "penalty_saves",    limit: 2
    t.integer  "penalty_missed",   limit: 2
    t.integer  "yellow_cards",     limit: 2
    t.integer  "red_cards",        limit: 2
    t.integer  "saves",            limit: 2
    t.integer  "bonus",            limit: 2
    t.integer  "esp",              limit: 2
    t.integer  "bps",              limit: 2
    t.integer  "net_transfers"
    t.decimal  "value",                       precision: 3, scale: 0
    t.integer  "points",           limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_score",       limit: 2
    t.integer  "opposition_score", limit: 2
  end

  add_index "player_histories", ["player_id"], name: "index_player_histories_on_player_id", using: :btree

  create_table "players", force: true do |t|
    t.string   "name",         limit: 30
    t.string   "firstname",    limit: 30
    t.string   "surname",      limit: 30
    t.integer  "club_id"
    t.integer  "fplplayer_id", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrapers", force: true do |t|
    t.string   "base_path"
    t.integer  "times_run"
    t.integer  "duration_minutes"
    t.integer  "number_of_players"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
