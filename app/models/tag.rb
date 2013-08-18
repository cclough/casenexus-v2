class Tag < ActiveRecord::Base
  attr_accessible :name, :category_id

  has_many :taggings, :dependent => :destroy
  has_many :taggables, :through => :taggings
  
end
