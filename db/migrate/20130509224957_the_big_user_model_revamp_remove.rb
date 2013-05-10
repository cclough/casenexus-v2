class TheBigUserModelRevampRemove < ActiveRecord::Migration

def change
	remove_column :users, :headline
	remove_column :users, :status
	remove_column :users, :status_moderated
	remove_column :users, :status_approved
end

end
