class CreateLanguagesUsers < ActiveRecord::Migration
  def change

    create_table :languages_users, :id => false do |t|
    	t.column :user_id, :integer
    	t.column :language_id, :integer
    end

    add_index :languages_users, [:user_id, :language_id], :unique => true
    
  end
end
