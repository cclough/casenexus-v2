class RemoveRecommendationsFromCases < ActiveRecord::Migration
  def change
    remove_column :cases, :recommendation1
    remove_column :cases, :recommendation2
    remove_column :cases, :recommendation3
  end
end
