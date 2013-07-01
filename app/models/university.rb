class University < ActiveRecord::Base
  has_many :users
  has_many :books

  has_one :channel

  attr_accessible :name, :image, :domain

  def image_file
    "universities/" + self.image
  end

end
