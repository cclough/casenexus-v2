class CreateCases < ActiveRecord::Migration
  def change

	  create_table "cases", :force => true do |t|

	    t.integer  "user_id",    :null => false
	    t.integer  "marker_id",  :null => false
	    t.date     "date",       :null => false
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
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  
	  end

	  add_index "cases", ["user_id"], :name => "index_cases_on_user_id"

  end
end
