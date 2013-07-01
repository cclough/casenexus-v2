class Channel < ActiveRecord::Base

  attr_accessible :country_id, :university_id

  has_many :channels_users
  has_many :users, :through => :channels_users

  belongs_to :country
  belongs_to :university


  def name
    
    if university_id.blank?
      Country.find(country_id).name
    else
      University.find(university_id).name
    end

  end

  def image

    if university_id.blank?
      Country.find(country_id).image_file unless Country.find(country_id).blank?
    else
      University.find(university_id).image_file
    end

  end

end
