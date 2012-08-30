class AddColumnStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :text
  end
end