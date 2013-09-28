class RemoveColumnsForHelpcheckboxInUser < ActiveRecord::Migration
  def change
    remove_column :users, :help_1_checked
    remove_column :users, :help_2_checked
    remove_column :users, :help_3_checked
    remove_column :users, :help_4_checked
    remove_column :users, :help_5_checked
    remove_column :users, :help_6_checked
  end
end
