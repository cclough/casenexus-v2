class Headsup < ActiveRecord::Base

  attr_accessible :email

  ### Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  ### Callback
  before_save { |headsup| headsup.email = headsup.email.downcase }
  before_create :send_newheadsup_email_to_admin

  def send_newheadsup_email_to_admin
    UserMailer.delay.newheadsup_to_admin(self)
  end

end
