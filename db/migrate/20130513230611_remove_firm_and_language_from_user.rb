class RemoveFirmAndLanguageFromUser < ActiveRecord::Migration
	def change
		remove_column :users, :firm_id
		remove_column :users, :language_id
	end
end
