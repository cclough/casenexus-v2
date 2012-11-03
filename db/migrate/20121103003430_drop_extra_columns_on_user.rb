class DropExtraColumnsOnUser < ActiveRecord::Migration
  def up
    remove_column :users, :industry
    remove_column :users, :picture_url
    remove_column :users, :public_profile_url
  end

  def down
    add_column :users, :industry, :string
    add_column :users, :picture_url, :string
    add_column :users, :public_profile_url, :string
  end
end
