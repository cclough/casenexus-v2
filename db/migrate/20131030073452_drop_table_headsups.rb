class DropTableHeadsups < ActiveRecord::Migration
  def change
    drop_table :headsups
  end

end
