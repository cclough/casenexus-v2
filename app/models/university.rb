class University < ActiveRecord::Base
  has_many :users

  attr_accessible :name, :image, :domain
end
