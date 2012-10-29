class RemoveNotesFromCases < ActiveRecord::Migration
	def change
		remove_column :cases, :notes
	end
end
