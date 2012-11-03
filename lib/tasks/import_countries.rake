require 'csv'

namespace :db do

	desc "Import countries from csv file"
	task :countries => [:environment] do

	  file = "db/countries.csv"

	  CSV.foreach(file, :headers => true) do |row|
	    Country.create ({
	      :name => row[0],
	      :code => row[1],
	      :lat => row[2],
	      :lng => row[3]
	    })
	  end
	end
	
end