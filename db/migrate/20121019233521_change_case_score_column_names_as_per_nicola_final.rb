class ChangeCaseScoreColumnNamesAsPerNicolaFinal < ActiveRecord::Migration
  def change

		remove_column :cases, :arithmetic
		remove_column :cases, :problemsolves
		remove_column :cases, :prioritises
		remove_column :cases, :sensechecks

		remove_column :cases, :articulates
		remove_column :cases, :concise
		remove_column :cases, :requestsinfo

		remove_column :cases, :stickstostructure
		remove_column :cases, :announcesdeviation
		remove_column :cases, :pushtoconclusion

		add_column :cases, :quantitativebasics, :integer
		add_column :cases, :problemsolving, :integer
		add_column :cases, :prioritisation, :integer
		add_column :cases, :sanitychecking, :integer

		add_column :cases, :articulation, :integer
		add_column :cases, :concision, :integer
		add_column :cases, :askingforinformation, :integer

		add_column :cases, :stickingtostructure, :integer
		add_column :cases, :announceschangedstructure, :integer
		add_column :cases, :pushingtoconclusion, :integer

  end
end
