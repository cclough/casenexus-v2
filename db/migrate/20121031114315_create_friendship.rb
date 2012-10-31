class CreateFriendship < ActiveRecord::Migration
  def up
    create_table :friendships do |t|
      t.integer :user_id, null: false
      t.integer :friend_id, null: false
      t.integer :status, null: false, :default => 0
      t.text :invitation_message

      t.datetime :accepted_at
      t.datetime :rejected_at
      t.datetime :blocked_at

      t.timestamps
    end

    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
  end

  def down
    drop_table :friendships
  end
end
