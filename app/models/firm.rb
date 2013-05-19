class Firm < ActiveRecord::Base
  attr_accessible :name

	has_many :firms_users
	has_many :firms, :through => :firms_users

end
