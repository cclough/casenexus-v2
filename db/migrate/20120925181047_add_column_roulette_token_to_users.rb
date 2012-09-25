class AddColumnRouletteTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :roulette_token, :string
  end
end
