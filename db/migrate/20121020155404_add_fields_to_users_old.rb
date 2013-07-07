class AddFieldsToUsersOld < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false, null: false

    add_column :users, :linkedin_uid, :string
    add_column :users, :linkedin_token, :string
    add_column :users, :linkedin_secret, :string

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :headline, :string

    add_column :users, :industry, :string
    add_column :users, :picture_url, :string
    add_column :users, :public_profile_url, :string

    add_column :users, :lat, :float
    add_column :users, :lng, :float
    add_column :users, :skype, :string
    add_column :users, :email_admin, :boolean, default: false, null: false
    add_column :users, :email_users, :boolean, default: false, null: false
    add_column :users, :completed, :boolean, default: false, null: false
    add_column :users, :status, :text
    add_column :users, :status_approved, :boolean, default: false, null: false
    add_column :users, :roulette_token, :string, null: false
    add_column :users, :city, :string
    add_column :users, :country, :string

    add_index :users, :roulette_token, unique: true
    add_index :users, :linkedin_uid
  end
end
