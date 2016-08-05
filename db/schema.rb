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

ActiveRecord::Schema.define(version: 20160804232518) do

  create_table "called_strike_percentages", force: :cascade do |t|
    t.integer "zone_id",                  limit: 4
    t.decimal "called_strike_percentage",             precision: 10
    t.string  "pitcher_hand",             limit: 255
    t.string  "batter_hand",              limit: 255
    t.integer "balls",                    limit: 4
    t.integer "strikes",                  limit: 4
    t.string  "pitch_type",               limit: 255
  end

  create_table "contact_percentages", force: :cascade do |t|
    t.integer "zone_id",            limit: 4
    t.decimal "contact_percentage",             precision: 10
    t.string  "pitcher_hand",       limit: 255
    t.string  "batter_hand",        limit: 255
    t.integer "balls",              limit: 4
    t.integer "strikes",            limit: 4
    t.string  "pitch_type",         limit: 255
  end

  create_table "games", force: :cascade do |t|
    t.integer  "home_team_id",                   limit: 4
    t.integer  "away_team_id",                   limit: 4
    t.integer  "attendance",                     limit: 4
    t.string   "stadium_name",                   limit: 255
    t.string   "home_lineup",                    limit: 255
    t.string   "away_lineup",                    limit: 255
    t.string   "home_atbats",                    limit: 255
    t.string   "home_runs_scored",               limit: 255
    t.string   "home_hits",                      limit: 255
    t.string   "home_doubles",                   limit: 255
    t.string   "home_triples",                   limit: 255
    t.string   "home_home_runs",                 limit: 255
    t.string   "home_RBI",                       limit: 255
    t.string   "home_walks",                     limit: 255
    t.string   "home_strikeouts",                limit: 255
    t.string   "home_stolen_bases",              limit: 255
    t.string   "home_caught_stealing",           limit: 255
    t.string   "home_errors",                    limit: 255
    t.string   "home_assists",                   limit: 255
    t.string   "home_putouts",                   limit: 255
    t.string   "home_chances",                   limit: 255
    t.string   "away_atbats",                    limit: 255
    t.string   "away_runs_scored",               limit: 255
    t.string   "away_hits",                      limit: 255
    t.string   "away_doubles",                   limit: 255
    t.string   "away_triples",                   limit: 255
    t.string   "away_home_runs",                 limit: 255
    t.string   "away_RBI",                       limit: 255
    t.string   "away_walks",                     limit: 255
    t.string   "away_strikeouts",                limit: 255
    t.string   "away_caught_stealing",           limit: 255
    t.string   "away_errors",                    limit: 255
    t.string   "away_assists",                   limit: 255
    t.string   "away_putouts",                   limit: 255
    t.string   "away_chances",                   limit: 255
    t.string   "home_pitchers",                  limit: 255
    t.string   "away_pitchers",                  limit: 255
    t.string   "home_outs_recorded",             limit: 255
    t.string   "home_hits_allowed",              limit: 255
    t.string   "home_runs_allowed",              limit: 255
    t.string   "home_earned_runs_allowed",       limit: 255
    t.string   "home_walks_allowed",             limit: 255
    t.string   "home_strikeouts_recorded",       limit: 255
    t.string   "home_home_runs_allowed",         limit: 255
    t.string   "home_total_pitches",             limit: 255
    t.string   "home_strikes_thrown",            limit: 255
    t.string   "home_balls_thrown",              limit: 255
    t.string   "home_intentional_walks_allowed", limit: 255
    t.string   "away_outs_recorded",             limit: 255
    t.string   "away_hits_allowed",              limit: 255
    t.string   "away_runs_allowed",              limit: 255
    t.string   "away_earned_runs_allowed",       limit: 255
    t.string   "away_walks_allowed",             limit: 255
    t.string   "away_strikeouts_recorded",       limit: 255
    t.string   "away_home_runs_allowed",         limit: 255
    t.string   "away_total_pitches",             limit: 255
    t.string   "away_strikes_thrown",            limit: 255
    t.string   "away_balls_thrown",              limit: 255
    t.string   "away_intentional_walks_allowed", limit: 255
    t.integer  "player_of_the_game",             limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "away_stolen_bases",              limit: 255
    t.string   "home_inning_scores",             limit: 255
    t.string   "away_inning_scores",             limit: 255
    t.text     "pbp",                            limit: 65535
    t.integer  "season_id",                      limit: 4
    t.integer  "game_number",                    limit: 4
  end

  create_table "pitch_locations", force: :cascade do |t|
    t.integer "zone_id",          limit: 4
    t.decimal "pitch_percentage",             precision: 10
    t.string  "pitcher_hand",     limit: 255
    t.string  "batter_hand",      limit: 255
    t.integer "balls",            limit: 4
    t.integer "strikes",          limit: 4
    t.string  "pitch_type",       limit: 255
  end

  create_table "players", force: :cascade do |t|
    t.integer  "team_id",                   limit: 4
    t.string   "first_name",                limit: 255
    t.string   "last_name",                 limit: 255
    t.integer  "age",                       limit: 4
    t.integer  "height",                    limit: 4
    t.integer  "weight",                    limit: 4
    t.string   "position",                  limit: 255
    t.integer  "salary",                    limit: 4
    t.integer  "power",                     limit: 4
    t.integer  "contact",                   limit: 4
    t.integer  "speed",                     limit: 4
    t.integer  "patience",                  limit: 4
    t.integer  "plate_vision",              limit: 4
    t.integer  "pull_amount",               limit: 4
    t.integer  "uppercut_amount",           limit: 4
    t.integer  "batting_average",           limit: 4
    t.integer  "movement",                  limit: 4
    t.integer  "control",                   limit: 4
    t.integer  "location",                  limit: 4
    t.integer  "agility",                   limit: 4
    t.integer  "reactionTime",              limit: 4
    t.integer  "armStrength",               limit: 4
    t.integer  "fieldGrounder",             limit: 4
    t.integer  "fieldLiner",                limit: 4
    t.integer  "fieldFlyball",              limit: 4
    t.integer  "fieldPopup",                limit: 4
    t.integer  "throwShort",                limit: 4
    t.integer  "throwMedium",               limit: 4
    t.integer  "throwLong",                 limit: 4
    t.integer  "intelligence",              limit: 4
    t.integer  "endurance",                 limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "atbats",                    limit: 4
    t.integer  "runs",                      limit: 4
    t.integer  "hits",                      limit: 4
    t.integer  "doubles",                   limit: 4
    t.integer  "triples",                   limit: 4
    t.integer  "home_runs",                 limit: 4
    t.integer  "rbi",                       limit: 4
    t.integer  "walks",                     limit: 4
    t.integer  "strikeouts",                limit: 4
    t.integer  "stolen_bases",              limit: 4
    t.integer  "caught_stealing",           limit: 4
    t.integer  "errors_committed",          limit: 4
    t.integer  "assists",                   limit: 4
    t.integer  "putouts",                   limit: 4
    t.integer  "chances",                   limit: 4
    t.integer  "outs_recorded",             limit: 4
    t.integer  "hits_allowed",              limit: 4
    t.integer  "runs_allowed",              limit: 4
    t.integer  "earned_runs_allowed",       limit: 4
    t.integer  "walks_allowed",             limit: 4
    t.integer  "strikeouts_recorded",       limit: 4
    t.integer  "home_runs_allowed",         limit: 4
    t.integer  "total_pitches",             limit: 4
    t.integer  "strikes_thrown",            limit: 4
    t.integer  "balls_thrown",              limit: 4
    t.integer  "intentional_walks_allowed", limit: 4
    t.integer  "zone_1_pitches",            limit: 4
    t.integer  "zone_2_pitches",            limit: 4
    t.integer  "zone_3_pitches",            limit: 4
    t.integer  "zone_4_pitches",            limit: 4
    t.integer  "zone_5_pitches",            limit: 4
    t.integer  "zone_6_pitches",            limit: 4
    t.integer  "zone_7_pitches",            limit: 4
    t.integer  "zone_8_pitches",            limit: 4
    t.integer  "zone_9_pitches",            limit: 4
    t.integer  "zone_10_pitches",           limit: 4
    t.integer  "zone_11_pitches",           limit: 4
    t.integer  "zone_12_pitches",           limit: 4
    t.integer  "zone_13_pitches",           limit: 4
    t.integer  "zone_14_pitches",           limit: 4
    t.integer  "zone_15_pitches",           limit: 4
    t.integer  "zone_16_pitches",           limit: 4
    t.integer  "zone_17_pitches",           limit: 4
    t.integer  "zone_18_pitches",           limit: 4
    t.integer  "zone_19_pitches",           limit: 4
    t.integer  "zone_20_pitches",           limit: 4
    t.integer  "zone_21_pitches",           limit: 4
    t.integer  "zone_22_pitches",           limit: 4
    t.integer  "zone_23_pitches",           limit: 4
    t.integer  "zone_24_pitches",           limit: 4
    t.integer  "zone_25_pitches",           limit: 4
    t.integer  "zone_26_pitches",           limit: 4
    t.integer  "zone_27_pitches",           limit: 4
    t.integer  "zone_28_pitches",           limit: 4
    t.integer  "zone_29_pitches",           limit: 4
    t.integer  "zone_30_pitches",           limit: 4
    t.integer  "zone_31_pitches",           limit: 4
    t.integer  "zone_32_pitches",           limit: 4
    t.integer  "zone_33_pitches",           limit: 4
    t.integer  "zone_34_pitches",           limit: 4
    t.integer  "zone_35_pitches",           limit: 4
    t.integer  "zone_36_pitches",           limit: 4
    t.integer  "zone_37_pitches",           limit: 4
    t.integer  "zone_38_pitches",           limit: 4
    t.integer  "zone_39_pitches",           limit: 4
    t.integer  "zone_40_pitches",           limit: 4
    t.integer  "zone_41_pitches",           limit: 4
    t.integer  "zone_42_pitches",           limit: 4
    t.integer  "zone_43_pitches",           limit: 4
    t.integer  "zone_44_pitches",           limit: 4
    t.integer  "zone_45_pitches",           limit: 4
    t.integer  "zone_46_pitches",           limit: 4
    t.integer  "zone_47_pitches",           limit: 4
    t.integer  "zone_48_pitches",           limit: 4
    t.integer  "zone_49_pitches",           limit: 4
    t.integer  "zone_50_pitches",           limit: 4
    t.integer  "zone_51_pitches",           limit: 4
    t.integer  "zone_52_pitches",           limit: 4
    t.integer  "zone_53_pitches",           limit: 4
    t.integer  "zone_54_pitches",           limit: 4
    t.integer  "zone_55_pitches",           limit: 4
    t.integer  "zone_56_pitches",           limit: 4
    t.integer  "zone_57_pitches",           limit: 4
    t.integer  "zone_58_pitches",           limit: 4
    t.integer  "zone_59_pitches",           limit: 4
    t.integer  "zone_60_pitches",           limit: 4
    t.integer  "zone_61_pitches",           limit: 4
    t.integer  "zone_62_pitches",           limit: 4
    t.integer  "zone_63_pitches",           limit: 4
    t.integer  "zone_64_pitches",           limit: 4
    t.integer  "zone_65_pitches",           limit: 4
    t.integer  "zone_66_pitches",           limit: 4
    t.integer  "zone_67_pitches",           limit: 4
    t.integer  "zone_68_pitches",           limit: 4
    t.integer  "zone_69_pitches",           limit: 4
    t.integer  "zone_70_pitches",           limit: 4
    t.integer  "zone_71_pitches",           limit: 4
    t.integer  "zone_72_pitches",           limit: 4
    t.string   "throwing_hand",             limit: 255
    t.string   "hitting_side",              limit: 255
    t.string   "pitch_1",                   limit: 255
    t.string   "pitch_2",                   limit: 255
    t.string   "pitch_3",                   limit: 255
    t.string   "pitch_4",                   limit: 255
    t.string   "pitch_5",                   limit: 255
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "next_game",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "swing_percentages", force: :cascade do |t|
    t.integer "zone_id",          limit: 4
    t.decimal "swing_percentage",             precision: 10
    t.string  "pitcher_hand",     limit: 255
    t.string  "batter_hand",      limit: 255
    t.integer "balls",            limit: 4
    t.integer "strikes",          limit: 4
    t.string  "pitch_type",       limit: 255
  end

  create_table "teams", force: :cascade do |t|
    t.string   "city",              limit: 255
    t.string   "name",              limit: 255
    t.string   "league",            limit: 255
    t.string   "division",          limit: 255
    t.string   "stadium",           limit: 255
    t.integer  "capacity",          limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "catcher",           limit: 4
    t.integer  "designated_hitter", limit: 4
    t.integer  "first_base",        limit: 4
    t.integer  "second_base",       limit: 4
    t.integer  "third_base",        limit: 4
    t.integer  "shortstop",         limit: 4
    t.integer  "left_field",        limit: 4
    t.integer  "center_field",      limit: 4
    t.integer  "right_field",       limit: 4
    t.integer  "lineup1",           limit: 4
    t.integer  "lineup2",           limit: 4
    t.integer  "lineup3",           limit: 4
    t.integer  "lineup4",           limit: 4
    t.integer  "lineup5",           limit: 4
    t.integer  "lineup6",           limit: 4
    t.integer  "lineup7",           limit: 4
    t.integer  "lineup8",           limit: 4
    t.integer  "lineup9",           limit: 4
    t.integer  "wins",              limit: 4
    t.integer  "losses",            limit: 4
    t.integer  "runs_scored",       limit: 4
    t.integer  "runs_allowed",      limit: 4
    t.text     "schedule",          limit: 65535
    t.integer  "streak",            limit: 4
    t.integer  "sp1",               limit: 4
    t.integer  "sp2",               limit: 4
    t.integer  "sp3",               limit: 4
    t.integer  "sp4",               limit: 4
    t.integer  "sp5",               limit: 4
    t.integer  "lr",                limit: 4
    t.integer  "mr1",               limit: 4
    t.integer  "mr2",               limit: 4
    t.integer  "mr3",               limit: 4
    t.integer  "su1",               limit: 4
    t.integer  "su2",               limit: 4
    t.integer  "cl",                limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "password_digest",   limit: 255
    t.string   "remember_digest",   limit: 255
    t.boolean  "admin",                         default: false
    t.string   "activation_digest", limit: 255
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.string   "reset_digest",      limit: 255
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
