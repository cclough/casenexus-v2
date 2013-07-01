class Channel < ActiveRecord::Base

  attr_accessible :country_id, :university_id

  has_many :channels_users
  has_many :users, :through => :channels_users

  belongs_to :country
  belongs_to :university

end
