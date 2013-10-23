class SiteContact < ActiveRecord::Base
  attr_accessible :subject, :email, :content

  ### Associations
  belongs_to :user

  ### Validations
  validates :subject, presence: true
  validates :email, presence: true
  validates :content, presence: true
  validates_format_of :email,
                      :with => /(^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$)|^$/i,
                      :message => "must be a valid email address"

  ### Callbacks
  after_create :send_mail_to_admin

  def send_mail_to_admin
    UserMailer.site_contact(self).deliver
  end

end
