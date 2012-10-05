class Country < ActiveRecord::Base
  attr_accessible :name, :code, :lat, :lng


  def self.inuse
  	User.order('country asc').select("country, city, lat, lng").uniq { |u| { country: u.country, city: u.city, lat: u.lat, lng: u.lng }}
  	# User.order('country asc').select("country, city").uniq { |u| { country: u.country, city: u.city } }
  end

end
