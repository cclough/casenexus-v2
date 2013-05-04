class RenameUniIdToUniversityIdInBooks < ActiveRecord::Migration
  def change
  	rename_column :books, :uni_id, :university_id
  end
end
