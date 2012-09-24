class RemoveEdexFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :education1
   	remove_column :users, :education2
  	remove_column :users, :education3
  	remove_column :users, :education1_from
  	remove_column :users, :education1_to
  	remove_column :users, :education2_from
  	remove_column :users, :education2_to
   	remove_column :users, :education3_from
  	remove_column :users, :education3_to
  	remove_column :users, :experience1
   	remove_column :users, :experience2
  	remove_column :users, :experience3
  	remove_column :users, :experience1_from
  	remove_column :users, :experience1_to
  	remove_column :users, :experience2_from
  	remove_column :users, :experience2_to
   	remove_column :users, :experience3_from
  	remove_column :users, :experience3_to
  end

  def down
  end
end
