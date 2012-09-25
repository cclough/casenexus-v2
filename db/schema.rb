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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925163251) do

  create_table "cases", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.date     "date",               :null => false
    t.text     "subject"
    t.string   "source"
    t.integer  "structure"
    t.text     "structure_comment"
    t.integer  "analytical"
    t.text     "analytical_comment"
    t.integer  "commercial"
    t.text     "commercial_comment"
    t.integer  "conclusion"
    t.text     "conclusion_comment"
    t.text     "comment"
    t.text     "notes"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "interviewer_id",     :null => false
  end

  add_index "cases", ["user_id"], :name => "index_cases_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",    :default => true
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "sender_id",                     :null => false
    t.string   "ntype",                         :null => false
    t.text     "content"
    t.date     "event_date"
    t.integer  "case_id"
    t.boolean  "read",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "universities", :force => true do |t|
    t.string "name"
    t.string "image"
    t.string "domain"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                                :null => false
    t.string   "last_name",                                 :null => false
    t.string   "email",                                     :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.float    "lat"
    t.float    "lng"
    t.string   "skype"
    t.string   "linkedin"
    t.boolean  "email_admin",            :default => true
    t.boolean  "email_users",            :default => true
    t.boolean  "accepts_tandc",          :default => false
    t.boolean  "admin",                  :default => false
    t.boolean  "completed",              :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "status"
    t.boolean  "approved",               :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "provider"
    t.string   "headline"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
