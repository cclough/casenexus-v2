class AddColumnsCanUpanddownvoteTousers < ActiveRecord::Migration

  def change
    add_column :users, :can_upvote, :boolean
    add_column :users, :can_downvote, :boolean
  end

end
