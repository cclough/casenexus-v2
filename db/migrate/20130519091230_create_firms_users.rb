class CreateFirmsUsers < ActiveRecord::Migration
  def change

  	drop_table :firms_users

    create_table :firms_users, :id => false do |t|
    	t.column :user_id, :integer
    	t.column :firm_id, :integer
    end

    add_index :firms_users, [:user_id, :firm_id], :unique => true
  end

end
