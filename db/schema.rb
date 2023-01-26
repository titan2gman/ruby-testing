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

ActiveRecord::Schema.define(version: 20140303130319) do

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "contact_id"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "points"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["associated_id", "associated_type"], name: "index_events_on_associated_id_and_associated_type"
  add_index "events", ["contact_id"], name: "index_events_on_contact_id"

  create_table "referrals", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referrals", ["contact_id"], name: "index_referrals_on_contact_id"

end
