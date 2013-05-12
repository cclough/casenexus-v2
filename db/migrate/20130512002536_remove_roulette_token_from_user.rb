class RemoveRouletteTokenFromUser < ActiveRecord::Migration
	def change
		remove_column :users, :roulette_token
	end
end
