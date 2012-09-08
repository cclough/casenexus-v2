class CreateNotifications < ActiveRecord::Migration
  
  def change

	  create_table "notifications", :force => true do |t|
	    t.integer  "user_id", 										:null => false
	    t.integer  "sender_id", 									:null => false
	    t.string   "ntype", 											:null => false
	    t.text     "content"
	    t.string   "url"
	    t.date     "event_date"
	    t.boolean  "read",       									:default => false
	    t.datetime "created_at",                  :null => false
	    t.datetime "updated_at",                  :null => false
	  end

	  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  end

end

