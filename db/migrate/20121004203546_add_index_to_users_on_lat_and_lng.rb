class AddIndexToUsersOnLatAndLng < ActiveRecord::Migration
  def self.up
    add_index  :users, [:lat, :lng]
  end

  def self.down
    remove_index  :users, [:lat, :lng]
  end
end
