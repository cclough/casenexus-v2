class DropUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string "first_name", null: false
      t.string "last_name", null: false
      t.string "email", null: false
      t.string "password_digest"
      t.string "remember_token"
      t.float "lat"
      t.float "lng"
      t.string "skype"
      t.string "linkedin"
      t.boolean "email_admin", default: true
      t.boolean "email_users", default: true
      t.boolean "accepts_tandc", default: false
      t.boolean "admin", default: false
      t.boolean "completed", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false

      t.text :status
      t.boolean :approved, default: false
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :provider
      t.string :headline
      t.string :roulette_token
      t.string :city
      t.string :country
    end

    add_index :users, ["email"], :name => "index_users_on_email", :unique => true
    add_index :users, ["remember_token"], :name => "index_users_on_remember_token"
    add_index :users, ["roulette_token"], :name => "index_users_on_roulette_token"
    add_index :users, [:lat, :lng]
  end
end
