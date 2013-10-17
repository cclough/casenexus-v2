class Headsup < ActiveRecord::Base

  attr_accessible :email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  before_save { |headsup| headsup.email = headsup.email.downcase }
  before_create :send_newheadsup_email_to_admin

  def send_newheadsup_email_to_admin
    UserMailer.newheadsup_to_admin(self).deliver
  end
end
