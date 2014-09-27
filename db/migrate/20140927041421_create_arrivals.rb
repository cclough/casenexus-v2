class CreateArrivals < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.string   "email",                        :null => false
      t.timestamps
    end
  end
end
