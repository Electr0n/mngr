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

ActiveRecord::Schema.define(version: 20151201085137) do

  create_table "events", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.date     "date"
    t.time     "time"
    t.string   "etype",              limit: 255
    t.string   "description",        limit: 255
    t.string   "gender",             limit: 255
    t.integer  "number",             limit: 4
    t.integer  "agemin",             limit: 4
    t.integer  "agemax",             limit: 4
    t.string   "location",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "events_users", id: false, force: :cascade do |t|
    t.integer "user_id",  limit: 4
    t.integer "event_id", limit: 4
  end

  add_index "events_users", ["event_id"], name: "index_events_users_on_event_id", using: :btree
  add_index "events_users", ["user_id"], name: "index_events_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",      null: false
    t.string   "encrypted_password",     limit: 255, default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "name",                   limit: 255, default: "Vasya", null: false
    t.string   "surname",                limit: 255
    t.date     "bday"
    t.string   "gender",                 limit: 255
    t.integer  "age",                    limit: 4
    t.integer  "phone",                  limit: 4
    t.string   "country",                limit: 255
    t.string   "city",                   limit: 255
    t.string   "hobby",                  limit: 255
    t.string   "about",                  limit: 255
    t.string   "role",                   limit: 255, default: "user",  null: false
    t.integer  "denied_t",               limit: 4
    t.boolean  "locked",                             default: false,   null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["age"], name: "index_users_on_age", using: :btree
  add_index "users", ["bday"], name: "index_users_on_bday", using: :btree
  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["denied_t"], name: "index_users_on_denied_t", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["hobby"], name: "index_users_on_hobby", using: :btree
  add_index "users", ["locked"], name: "index_users_on_locked", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["surname"], name: "index_users_on_surname", using: :btree

end
