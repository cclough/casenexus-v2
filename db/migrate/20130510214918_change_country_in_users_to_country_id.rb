class ChangeCountryInUsersToCountryId < ActiveRecord::Migration
	def change
		remove_column :users, :country
		add_column :users, :country_id, :integer
	end
end
