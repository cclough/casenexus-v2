class Country < ActiveRecord::Base
  attr_accessible :name, :code, :lat, :lng

  class << self
    def in_use
      User.order('country asc').select("country, city, lat, lng").uniq { |u| { country: u.country, city: u.city, lat: u.lat, lng: u.lng }}
    end
  end
end
