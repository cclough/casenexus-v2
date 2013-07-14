class Country < ActiveRecord::Base
  attr_accessible :name, :code, :lat, :lng

  has_many :users
  
  def image_file
  	"countries/" + self.code + ".png"
  end

  class << self
    def in_use
      Country.order("name asc").joins(:users).where("admin = false").where("completed = true").where("country_id > 0").uniq
    end
  end
end
