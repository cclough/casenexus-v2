class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer		"user_id", :null => false
      t.string		"title"
      t.text		  "content"
      t.integer		"view_count"
      t.timestamps
    end
  end
end
