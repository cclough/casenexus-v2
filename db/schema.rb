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

ActiveRecord::Schema.define(:version => 20121108141339) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "cases", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.date     "date",                      :null => false
    t.text     "subject"
    t.string   "source"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "interviewer_id",            :null => false
    t.integer  "rapport"
    t.integer  "approachupfront"
    t.text     "interpersonal_comment"
    t.text     "businessanalytics_comment"
    t.text     "structure_comment"
    t.text     "recommendation1"
    t.text     "recommendation2"
    t.text     "recommendation3"
    t.integer  "quantitativebasics"
    t.integer  "problemsolving"
    t.integer  "prioritisation"
    t.integer  "sanitychecking"
    t.integer  "articulation"
    t.integer  "concision"
    t.integer  "askingforinformation"
    t.integer  "stickingtostructure"
    t.integer  "announceschangedstructure"
    t.integer  "pushingtoconclusion"
  end

  add_index "cases", ["user_id"], :name => "index_cases_on_user_id"

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "code"
    t.float  "lat"
    t.float  "lng"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.integer  "friend_id",                         :null => false
    t.integer  "status",             :default => 0, :null => false
    t.text     "invitation_message"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "blocked_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invited_id"
    t.string   "code"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "invitations", ["invited_id"], :name => "index_invitations_on_invited_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "sender_id",                           :null => false
    t.string   "ntype",                               :null => false
    t.text     "content"
    t.date     "event_date"
    t.boolean  "read",             :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "notificable_id"
    t.string   "notificable_type"
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "site_contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "universities", :force => true do |t|
    t.string "name"
    t.string "image"
    t.string "domain"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false, :null => false
    t.string   "linkedin_uid"
    t.string   "linkedin_token"
    t.string   "linkedin_secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.float    "lat"
    t.float    "lng"
    t.string   "skype"
    t.boolean  "completed",              :default => false, :null => false
    t.text     "status"
    t.boolean  "status_approved",        :default => false, :null => false
    t.string   "roulette_token",                            :null => false
    t.string   "city"
    t.string   "country"
    t.integer  "university_id"
    t.datetime "last_online_at"
    t.boolean  "status_moderated",       :default => false, :null => false
    t.boolean  "email_admin",            :default => true
    t.boolean  "email_users",            :default => true
    t.boolean  "help_1_checked",         :default => true,  :null => false
    t.boolean  "help_2_checked",         :default => true,  :null => false
    t.boolean  "help_3_checked",         :default => true,  :null => false
    t.boolean  "help_4_checked",         :default => true,  :null => false
    t.boolean  "help_5_checked",         :default => true,  :null => false
    t.boolean  "help_6_checked",         :default => true,  :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["linkedin_uid"], :name => "index_users_on_linkedin_uid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["roulette_token"], :name => "index_users_on_roulette_token", :unique => true
  add_index "users", ["university_id"], :name => "index_users_on_university_id"

end
