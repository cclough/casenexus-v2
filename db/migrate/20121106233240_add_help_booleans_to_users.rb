class AddHelpBooleansToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :help_1, :boolean, default: false
   	add_column :users, :help_2, :boolean, default: false
   	add_column :users, :help_3, :boolean, default: false
   	add_column :users, :help_4, :boolean, default: false
   	add_column :users, :help_5, :boolean, default: false
   	add_column :users, :help_6, :boolean, default: false
  end
end
