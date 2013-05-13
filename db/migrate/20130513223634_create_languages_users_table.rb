class CreateLanguagesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :languages_users, :id => false do |t|
        t.references :language
        t.references :user
    end
    add_index :languages_users, [:language_id, :user_id]
    add_index :languages_users, [:user_id, :language_id]
  end

  def self.down
    drop_table :languages_users
  end
end
