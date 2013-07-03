class RemoveDateSubjectAndSourceAddBookableToCases < ActiveRecord::Migration
    def up
      remove_column :cases, :date
      add_column :cases, :book_id, :integer
    end

    def down
      add_column :cases, :date, :datetime
      remove_column :cases, :book_id, :integer
    end
end
