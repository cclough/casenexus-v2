class RemoveOmniauthLinkedinFields < ActiveRecord::Migration
  def change
    remove_column :users, :linkedin_uid
    remove_column :users, :linkedin_token
    remove_column :users, :linkedin_secret
    remove_column :users, :username
  end
end
