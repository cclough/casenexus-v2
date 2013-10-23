class University < ActiveRecord::Base
  attr_accessible :name, :image, :domain, :enabled

  ### Assocaitions
  has_many :users
  has_many :books

  def image_file
    "universities/" + self.image
  end

  def self.enabled
    where(enabled: true)
  end

end
