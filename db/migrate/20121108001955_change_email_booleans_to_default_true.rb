class ChangeEmailBooleansToDefaultTrue < ActiveRecord::Migration
	def change
		remove_column :users, :email_admin
		remove_column :users, :email_users
		add_column :users, :email_admin, :boolean, default: true
		add_column :users, :email_users, :boolean, default: true
	end
end
