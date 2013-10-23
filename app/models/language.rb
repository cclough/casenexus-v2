class Language < ActiveRecord::Base
  attr_accessible :name, :country_code

  ### Associations
	has_many :languages_users
	has_many :users, :through => :languages_users
  
end
