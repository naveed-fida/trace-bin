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

ActiveRecord::Schema.define(version: 20170412213441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "controller_events", force: :cascade do |t|
    t.string   "controller"
    t.string   "action"
    t.string   "path"
    t.string   "format"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "duration"
    t.integer  "cycle_transaction_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "cycle_transactions", force: :cascade do |t|
    t.string   "transaction_type"
    t.string   "name"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "duration"
    t.json     "data"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sql_events", force: :cascade do |t|
    t.string   "query"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "duration"
    t.integer  "cycle_transaction_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "template_events", force: :cascade do |t|
    t.text     "file"
    t.string   "layout"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "duration"
    t.integer  "cycle_transaction_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
