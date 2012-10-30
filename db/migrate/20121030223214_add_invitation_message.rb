class AddInvitationMessage < ActiveRecord::Migration
  def up
    add_column :friendships, :invitation_message, :text
  end

  def down
    remove_column :friendships, :invitation_message
  end
end
