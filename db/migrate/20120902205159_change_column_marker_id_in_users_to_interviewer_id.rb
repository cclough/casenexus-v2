class ChangeColumnMarkerIdInUsersToInterviewerId < ActiveRecord::Migration
	def change
		remove_column :cases, :marker_id
		add_column :cases, :interviewer_id, :integer, :null => false
	end
end
