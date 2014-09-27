class Arrival < ActiveRecord::Base
  attr_accessible :email

  before_save { |arrival| arrival.email = arrival.email.downcase }
end
