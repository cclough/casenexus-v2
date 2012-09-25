class AddColumnImageToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :image, :string
  end
end
