class RemoveTableSiteBugs < ActiveRecord::Migration
	def change
		drop_table :site_bugs
	end
end
