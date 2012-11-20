class RenameFeedbackTableToSiteBug < ActiveRecord::Migration
    def change
        rename_table :feedbacks, :site_bugs
    end 
end
