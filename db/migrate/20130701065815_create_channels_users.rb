class CreateChannelsUsers < ActiveRecord::Migration
  def change
    create_table :channels_users, :id => false do |t|
      t.column :user_id, :integer
      t.column :channel_id, :integer
    end

    add_index :channels_users, [:user_id, :channel_id], :unique => true
  end
end

