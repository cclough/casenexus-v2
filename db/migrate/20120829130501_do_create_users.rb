class DoCreateUsers < ActiveRecord::Migration
  def change

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
	    t.boolean  "email_admin",      										:default => true
	    t.boolean  "email_users",      										:default => true
	    t.boolean  "accepts_tandc",     									:default => false
	    t.boolean  "admin",            										:default => false
	    t.boolean  "completed",        										:default => false
	    t.datetime "created_at",                          :null => false
	    t.datetime "updated_at",                          :null => false
	  end

	  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
	  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  end
end
