class RemoveTimeZoneDefaultUtc < ActiveRecord::Migration
  def change
    change_column_default(:users, :time_zone, nil)
  end
end
