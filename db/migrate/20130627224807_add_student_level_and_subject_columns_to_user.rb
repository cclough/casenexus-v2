class AddStudentLevelAndSubjectColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :degree_level, :integer
  	add_column :users, :subject_id, :integer
  end
end
