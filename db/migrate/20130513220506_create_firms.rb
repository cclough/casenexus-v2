class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
  	  t.text         "name"
      t.timestamps
    end
  end
end
