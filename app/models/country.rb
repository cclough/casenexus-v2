class Country < ActiveRecord::Base
  attr_accessible :name, :code, :lat, :lng

  has_many :users
  
  def image_file
  	"countries/" + self.code + ".png"
  end

  class << self
    def in_use_chosen
      users = User.where("length(country_id) > 0").order('country asc').select("country, city, lat, lng")
      records = {}
      users.each { |user| records["#{user.country}#{user.city}"] = user unless records["#{user.country}#{user.city}"] }
      records.collect { |k, u| { country: u.country, city: u.city, lat: u.lat, lng: u.lng } }
    end

    def in_use
      Country.order("name asc").joins(:users).where("admin = false").where("completed = true").where("country_id > 0").uniq
    end
  end
end
