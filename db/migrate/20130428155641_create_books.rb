class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|

      t.timestamps

	    t.string   "btype",          :null => false
	    t.string   "title",          :null => false
	    t.string   "source_title",   :null => false
	    t.integer  "uni_id"
	    t.string   "author"
	    t.string   "author_url"
	    t.text     "desc",           :null => false
	    t.text     "url",            :null => false
	    t.text     "thumb"
	    t.float    "average_rating", :default => 0.0
	    t.boolean  "approved",       :default => true

    end
  end
end
