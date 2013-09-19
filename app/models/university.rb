class University < ActiveRecord::Base
  attr_accessible :name, :image, :domain

  has_many :users
  has_many :books


  def image_file
    "universities/" + self.image
  end

end
