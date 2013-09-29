class AddColumnReadToCases < ActiveRecord::Migration
  def change
    add_column :cases, :read, :boolean, :default => false
  end
end
