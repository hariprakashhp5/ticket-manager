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

ActiveRecord::Schema.define(version: 20160507185916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "add_uid_to_trackers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operators", force: :cascade do |t|
    t.integer  "region_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packs", force: :cascade do |t|
    t.integer  "region_id"
    t.integer  "operator_id"
    t.string   "price"
    t.string   "offer"
    t.string   "validity"
    t.text     "description"
    t.text     "tag"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "connection_type"
    t.integer  "pack_type"
    t.string   "caty"
  end

  create_table "prlinks", force: :cascade do |t|
    t.integer  "region_id"
    t.integer  "operator_id"
    t.string   "link1"
    t.string   "link2"
    t.string   "link3"
    t.string   "link4"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackers", force: :cascade do |t|
    t.string   "ticket_id"
    t.string   "integer"
    t.string   "created"
    t.string   "eta"
    t.string   "finished"
    t.string   "tow"
    t.string   "owner"
    t.integer  "noc"
    t.string   "staging"
    t.string   "comp"
    t.string   "disc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "uid"
    t.integer  "bugs"
    t.string   "status"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
