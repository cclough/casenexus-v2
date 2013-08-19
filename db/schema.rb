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

ActiveRecord::Schema.define(:version => 20130815001312) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id", :null => false
    t.integer  "user_id",     :null => false
    t.text     "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "books", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "btype",                            :null => false
    t.string   "title",                            :null => false
    t.string   "source_title"
    t.integer  "university_id"
    t.string   "author"
    t.string   "author_url"
    t.text     "desc"
    t.text     "url",                              :null => false
    t.text     "thumb"
    t.float    "average_rating", :default => 0.0
    t.boolean  "approved",       :default => true
    t.integer  "chart_num"
    t.integer  "difficulty"
  end

  create_table "cases", :force => true do |t|
    t.integer  "user_id",                   :null => false
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
    t.integer  "book_id"
  end

  add_index "cases", ["user_id"], :name => "index_cases_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.float    "rating"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "code"
    t.float  "lat"
    t.float  "lng"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",                  :null => false
    t.integer  "partner_id",               :null => false
    t.datetime "datetime",                 :null => false
    t.integer  "book_id_usertoprepare"
    t.integer  "book_id_partnertoprepare"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
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

  create_table "languages", :force => true do |t|
    t.text "name"
    t.text "country_code"
  end

  create_table "languages_users", :force => true do |t|
    t.integer "user_id"
    t.integer "language_id"
  end

  add_index "languages_users", ["user_id", "language_id"], :name => "index_languages_users_on_user_id_and_language_id", :unique => true

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

  create_table "points", :force => true do |t|
    t.integer  "user_id"
    t.integer  "method_id"
    t.string   "pointable_type"
    t.integer  "pointable_id"
    t.datetime "created_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "approved",   :default => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "title"
    t.text     "content"
    t.integer  "view_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "site_contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id",        :null => false
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
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
    t.string   "username",                                  :null => false
    t.float    "lat"
    t.float    "lng"
    t.string   "skype"
    t.boolean  "completed",              :default => false, :null => false
    t.string   "city"
    t.integer  "university_id"
    t.datetime "last_online_at"
    t.boolean  "email_admin",            :default => true
    t.boolean  "email_users",            :default => true
    t.boolean  "help_1_checked",         :default => true,  :null => false
    t.boolean  "help_2_checked",         :default => true,  :null => false
    t.boolean  "help_3_checked",         :default => true,  :null => false
    t.boolean  "help_4_checked",         :default => true,  :null => false
    t.boolean  "help_5_checked",         :default => true,  :null => false
    t.boolean  "help_6_checked",         :default => true,  :null => false
    t.integer  "cases_external"
    t.boolean  "active",                 :default => true
    t.integer  "country_id"
    t.string   "time_zone",              :default => "UTC"
    t.integer  "degree_level"
    t.integer  "subject_id"
    t.boolean  "can_upvote"
    t.boolean  "can_downvote"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["linkedin_uid"], :name => "index_users_on_linkedin_uid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["university_id"], :name => "index_users_on_university_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
