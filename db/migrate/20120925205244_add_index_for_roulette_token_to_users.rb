class AddIndexForRouletteTokenToUsers < ActiveRecord::Migration
  def change
  	add_index "users", ["roulette_token"], :name => "index_users_on_roulette_token"
  end
end
