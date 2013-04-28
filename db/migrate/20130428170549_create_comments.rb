class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

    t.timestamps

    t.integer  "user_id",          :null => false
    t.text     "content",          :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.float    "rating",           :default => 0.0

    end
  end
end
