class AddColumnDifficultyToBooks < ActiveRecord::Migration
  def change
    add_column :books, :difficulty, :integer
  end
end
