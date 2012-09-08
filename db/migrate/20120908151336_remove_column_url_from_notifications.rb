class RemoveColumnUrlFromNotifications < ActiveRecord::Migration
	def change
		remove_column :notifications, :url
		add_column :notifications, :case_id, :integer
	end
end
