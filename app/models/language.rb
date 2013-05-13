class Language < ActiveRecord::Base
  attr_accessible :name, :country_code

  has_and_belongs_to_many :users
end
