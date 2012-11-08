class UpdateHelpForUsers < ActiveRecord::Migration
  def up
    remove_column :users, :help_1
    remove_column :users, :help_2
    remove_column :users, :help_3
    remove_column :users, :help_4
    remove_column :users, :help_5
    remove_column :users, :help_6

    add_column :users, :help_1_checked, :boolean, null: false, default: true
    add_column :users, :help_2_checked, :boolean, null: false, default: true
    add_column :users, :help_3_checked, :boolean, null: false, default: true
    add_column :users, :help_4_checked, :boolean, null: false, default: true
    add_column :users, :help_5_checked, :boolean, null: false, default: true
    add_column :users, :help_6_checked, :boolean, null: false, default: true
  end

  def down
    remove_column :users, :help_1_checked
    remove_column :users, :help_2_checked
    remove_column :users, :help_3_checked
    remove_column :users, :help_4_checked
    remove_column :users, :help_5_checked
    remove_column :users, :help_6_checked

    add_column :users, :help_1, :boolean, default: false
    add_column :users, :help_2, :boolean, default: false
    add_column :users, :help_3, :boolean, default: false
    add_column :users, :help_4, :boolean, default: false
    add_column :users, :help_5, :boolean, default: false
    add_column :users, :help_6, :boolean, default: false
  end
end
