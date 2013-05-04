class RemoveTableComments < ActiveRecord::Migration

  def change

  	drop_table :comments


    create_table :comments do |t|

	    t.timestamps

	    t.integer  "user_id"
	    t.text     "content"
	    t.integer  "commentable_id"
	    t.string   "commentable_type"
	    t.float    "rating",           :default => 0.0

    end
  end
end
