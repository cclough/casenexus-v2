class RemoteColumnCommentFromCase < ActiveRecord::Migration
	def change
		remove_column :cases, :comment
	end
end
