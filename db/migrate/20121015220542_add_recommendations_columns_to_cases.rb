class AddRecommendationsColumnsToCases < ActiveRecord::Migration
	def change
		add_column :cases, :recommendation1, :text
		add_column :cases, :recommendation2, :text
		add_column :cases, :recommendation3, :text
	end
end
