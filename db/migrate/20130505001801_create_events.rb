class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer     "user_id",         :null => false
      t.integer     "partner_id",      :null => false
      t.datetime    "datetime",        :null => false
      t.integer     "book_id_usertoprepare"
      t.integer     "book_id_partnertoprepare"
      t.timestamps
    end
  end
end
