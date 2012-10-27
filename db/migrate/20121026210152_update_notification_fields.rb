class UpdateNotificationFields < ActiveRecord::Migration
  def up
    remove_column :notifications, :case_id
    add_column :notifications, :notificable_id, :integer
    add_column :notifications, :notificable_type, :string
  end

  def down
    remove_column :notifications, :notificable_id
    remove_column :notifications, :notificable_type
    add_column :notifications, :case_id, :integer
  end
end
