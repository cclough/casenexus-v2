class Feedback < ActiveRecord::Base
  belongs_to :user

  attr_accessible :subject, :content

  validates :subject, presence: true
  validates :content, presence: true

  after_create :send_mail_to_admin

  def send_mail_to_admin
    UserMailer.site_feedback(self).deliver
  end

end
