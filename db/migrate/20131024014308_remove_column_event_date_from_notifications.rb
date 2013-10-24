class RemoveColumnEventDateFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :event_date
  end
end
