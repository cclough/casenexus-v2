class University < ActiveRecord::Base
  has_many :users
  has_many :books

  attr_accessible :name, :image, :domain
end
