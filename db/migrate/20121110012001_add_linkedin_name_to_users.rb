class AddLinkedinNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_name, :string, after: 'linkedin_secret'
  end
end
