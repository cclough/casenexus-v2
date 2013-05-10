class RemoveLinkedInNameFromUsers < ActiveRecord::Migration
	def change
		remove_column :users, :linkedin_name
	end
end
