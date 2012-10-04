class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
	    t.string :name
	    t.string :code
	    t.float :lat
	    t.float :lng
    end
  end
end