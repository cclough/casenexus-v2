class Arrival < ActiveRecord::Base
  attr_accessible :email

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "address isn't valid" 
  validates_uniqueness_of :email, message: "has already been recorded"

  before_save { |arrival| arrival.email = arrival.email.downcase }
end
