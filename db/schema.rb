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

ActiveRecord::Schema.define(version: 20140423090928) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "link"
    t.string   "privacy"
    t.datetime "updated_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "prev_content_id"
    t.string   "title"
    t.string   "description"
    t.string   "service_type"
    t.string   "source"
    t.string   "url"
    t.integer  "list_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "itemtype"
    t.string   "url_html"
    t.string   "snippet"
  end

  add_index "items", ["list_id", "user_id"], name: "index_items_on_list_id_and_user_id"

  create_table "lists", force: true do |t|
    t.boolean  "draft_flag"
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "updated_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "lists", ["user_id", "group_id"], name: "index_lists_on_user_id_and_group_id"

  create_table "user_groups", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "role"
  end

  add_index "user_groups", ["group_id", "user_id"], name: "index_user_groups_on_group_id_and_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
