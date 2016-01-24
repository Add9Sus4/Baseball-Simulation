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

ActiveRecord::Schema.define(version: 20160123211158) do

  create_table "players", force: :cascade do |t|
    t.integer  "team_id",         limit: 4
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.integer  "age",             limit: 4
    t.integer  "height",          limit: 4
    t.integer  "weight",          limit: 4
    t.string   "position",        limit: 255
    t.integer  "salary",          limit: 4
    t.integer  "power",           limit: 4
    t.integer  "contact",         limit: 4
    t.integer  "speed",           limit: 4
    t.integer  "patience",        limit: 4
    t.integer  "plate_vision",    limit: 4
    t.integer  "pull_amount",     limit: 4
    t.integer  "uppercut_amount", limit: 4
    t.integer  "batting_average", limit: 4
    t.integer  "movement",        limit: 4
    t.integer  "control",         limit: 4
    t.integer  "location",        limit: 4
    t.integer  "agility",         limit: 4
    t.integer  "reactionTime",    limit: 4
    t.integer  "armStrength",     limit: 4
    t.integer  "fieldGrounder",   limit: 4
    t.integer  "fieldLiner",      limit: 4
    t.integer  "fieldFlyball",    limit: 4
    t.integer  "fieldPopup",      limit: 4
    t.integer  "throwShort",      limit: 4
    t.integer  "throwMedium",     limit: 4
    t.integer  "throwLong",       limit: 4
    t.integer  "intelligence",    limit: 4
    t.integer  "endurance",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "city",              limit: 255
    t.string   "name",              limit: 255
    t.string   "league",            limit: 255
    t.string   "division",          limit: 255
    t.string   "stadium",           limit: 255
    t.integer  "capacity",          limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "catcher",           limit: 4
    t.integer  "designated_hitter", limit: 4
    t.integer  "first_base",        limit: 4
    t.integer  "second_base",       limit: 4
    t.integer  "third_base",        limit: 4
    t.integer  "shortstop",         limit: 4
    t.integer  "left_field",        limit: 4
    t.integer  "center_field",      limit: 4
    t.integer  "right_field",       limit: 4
    t.integer  "bench1",            limit: 4
    t.integer  "bench2",            limit: 4
    t.integer  "bench3",            limit: 4
    t.integer  "bench4",            limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
