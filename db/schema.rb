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

ActiveRecord::Schema.define(:version => 20120830222348) do

  create_table "users", :force => true do |t|
    t.string   "first_name",                          :null => false
    t.string   "last_name",                           :null => false
    t.string   "email",                               :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.float    "lat"
    t.float    "lng"
    t.string   "education1"
    t.string   "education2"
    t.string   "education3"
    t.string   "experience1"
    t.string   "experience2"
    t.string   "experience3"
    t.date     "education1_from"
    t.date     "education1_to"
    t.date     "education2_from"
    t.date     "education2_to"
    t.date     "education3_from"
    t.date     "education3_to"
    t.date     "experience1_from"
    t.date     "experience1_to"
    t.date     "experience2_from"
    t.date     "experience2_to"
    t.date     "experience3_from"
    t.date     "experience3_to"
    t.string   "skype"
    t.string   "linkedin"
    t.boolean  "email_admin",      :default => true
    t.boolean  "email_users",      :default => true
    t.boolean  "accepts_tandc",    :default => false
    t.boolean  "admin",            :default => false
    t.boolean  "completed",        :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.text     "status"
    t.boolean  "approved",         :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
