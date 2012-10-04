class Country < ActiveRecord::Base
  attr_accessible :name, :code, :lat, :lng
end
