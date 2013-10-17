class CreateHeadsups < ActiveRecord::Migration
  def change
    create_table :headsups do |t|
      t.string   "email"
      t.timestamps
    end
  end
end
