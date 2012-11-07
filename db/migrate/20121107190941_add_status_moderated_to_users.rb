class AddStatusModeratedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status_moderated, :boolean, null: false, default: false, after: 'status_approved'
  end
end
