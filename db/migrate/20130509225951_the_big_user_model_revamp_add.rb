class TheBigUserModelRevampAdd < ActiveRecord::Migration

	def change
		add_column :users, :language_id, :integer			:null => false
		add_column :users, :firm_id, :integer				:null => false
		add_column :users, :cases_external, :integer
		add_column :active, :boolean						:default => true
	end

end