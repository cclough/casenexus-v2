class AddColumnEnabledToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :enabled, :boolean
  end
end
