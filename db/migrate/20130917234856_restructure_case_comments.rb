class RestructureCaseComments < ActiveRecord::Migration
  def change
    remove_column :cases, :interpersonal_comment
    remove_column :cases, :businessanalytics_comment
    remove_column :cases, :structure_comment

    add_column :cases, :main_comment, :text
  end
end
