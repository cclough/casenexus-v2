class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer     "user_id",         :null => false
      t.integer     "partner_id"
      t.datetime    "datetime"
      t.integer     "user_book_id"
      t.integer     "partner_book_id"
      t.timestamps
    end
  end
end
