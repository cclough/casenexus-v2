class AddNicolaCaseScoring < ActiveRecord::Migration
	def change
		remove_column :cases, :structure
		remove_column :cases, :analytical
		remove_column :cases, :commercial
		remove_column :cases, :conclusion
		remove_column :cases, :structure_comment
		remove_column :cases, :analytical_comment
		remove_column :cases, :commercial_comment
		remove_column :cases, :conclusion_comment

		add_column :cases, :arithmetic, :integer
		add_column :cases, :problemsolves, :integer
		add_column :cases, :prioritises, :integer
		add_column :cases, :sensechecks, :integer

		add_column :cases, :rapport, :integer
		add_column :cases, :articulates, :integer
		add_column :cases, :concise, :integer
		add_column :cases, :requestsinfo, :integer

		add_column :cases, :approachupfront, :integer
		add_column :cases, :stickstostructure, :integer
		add_column :cases, :announcesdeviation, :integer
		add_column :cases, :pushtoconclusion, :integer

		add_column :cases, :interpersonal_comment, :text
		add_column :cases, :businessanalytics_comment, :text
		add_column :cases, :structure_comment, :text

	end






end
