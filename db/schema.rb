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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20151205091539) do

  create_table "aliases", force: :cascade do |t|
    t.string   "company_id"
    t.text     "keyword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "owner"
    t.integer  "number"
    t.datetime "registered"
    t.integer  "good_count"
    t.integer  "bad_count"
    t.text     "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evidences", force: :cascade do |t|
    t.string   "resource_id"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "guilts", force: :cascade do |t|
    t.string   "name"
    t.string   "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "acord_type"
    t.string   "acord_content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "scores", force: :cascade do |t|
    t.boolean  "good_or_bad"
    t.string   "company_id"
    t.string   "voting_ip"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end
=======
ActiveRecord::Schema.define(version: 0) do
>>>>>>> 1669f5fc0db38cfa48fb9c11151e65a2ceed4c66

end
