class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer     "user_id",         :null => false
      t.integer     "partner_id",      :null => false
      t.datetime    "datetime",        :null => false
      t.integer     "book_id_user"
      t.integer     "book_id_partner"
      t.timestamps
    end
  end
end
