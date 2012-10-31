class DropFriendships < ActiveRecord::Migration
  def up
    drop_table :friendships
  end

  def down
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :blocker_id
      t.boolean :pending, :default => true
      t.text :invitation_message
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
