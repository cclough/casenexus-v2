class CleanUserTableBeforeLaunch < ActiveRecord::Migration
  def change
    remove_column :users, :subject_id
    remove_column :users, :can_upvote
    remove_column :users, :can_downvote
  end
end
