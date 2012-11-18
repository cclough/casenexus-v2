class Notification < ActiveRecord::Base
  attr_accessible :user, :user_id, :sender, :sender_id, :ntype, :content, :event_date, :read,
                  :notificable_id, :notificable_type, :notificable

  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :notificable, polymorphic: true

  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :sender_id, presence: true, if: Proc.new { |n| n.sender.nil? }
  validates :sender, presence: true, if: Proc.new { |n| n.sender_id.nil? }
  validates :notificable_id, presence: true, if: Proc.new { |n| n.ntype == 'feedback' }
  validates :notificable_type, presence: true, if: Proc.new { |n| n.ntype == 'feedback' }

  validate :no_notification_to_self

  validates :content, length: { maximum: 500 }

  validates_presence_of :content, if: lambda { self.ntype == 'message' }

  after_create :send_email

  def self.valid_types;%w(welcome message feedback feedback_req friendship_req friendship_app); end

  validates :ntype, presence: true, length: { maximum: 20 }, inclusion: { in: self.valid_types }
  validate :no_notification_to_self

  class << self

    def readed
      where(read: true)
    end

    def unread
      where(read: false)
    end

    def for_display
      where("ntype != 'welcome'")
    end
  end

  scoped_search in: :sender, on: [:first_name, :last_name]
  scoped_search on: [:content]

  def read!
    update_attribute(:read, true)
  end

  def content_trunc
    if self.ntype == "friendship_app"
      "Contact Accepted"
    else
      content.truncate(35, :separator => ' ') unless (content == nil)
    end
  end

  def title
    case ntype
      when "welcome"
        "Message"
      when "message"
        "Message"
      when "feedback"
        "New feedback"
      when "feedback_req"
        "Feedback request"
      when "friendship_req"
        "Case partner request"
      when "friendship_app"
        "Case partner accepted"
    end    
  end

  def url
    host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'

    case ntype
      when "welcome"
        Rails.application.routes.url_helpers.root_url(host: host)
      when "message"
        Rails.application.routes.url_helpers.notification_url(id, host: host)
      when "feedback"
        Rails.application.routes.url_helpers.case_url(notificable_id, host: host)
      when "feedback_req"
        Rails.application.routes.url_helpers.new_case_url(host: host)
      when "friendship_req"
        Rails.application.routes.url_helpers.friendship_url(sender_id, host: host)
      when "friendship_app"
        Rails.application.routes.url_helpers.root_url(host: host)
    end
  end

  class << self
    def header(user)
      user.notifications.where(read: false).limit(5).order('created_at desc').reverse
    end

    def history(from_id, to_id)
      for_display.where("(sender_id = ? and user_id = ?) or (sender_id = ? and user_id = ?)",
            from_id, to_id,
            to_id, from_id).where("ntype in (?)", %w(message feedback feedback_req))
    end
  end

  private

  def no_notification_to_self
    if !user_id.blank?
      errors.add(:user_id, "cannot send notification to self") if self.user_id == self.sender_id
    end
  end

  def send_email
    return if self.user.email_users == false
    case self.ntype
      when "welcome"
        UserMailer.welcome(self.user,
                           self.url).deliver
      when "feedback"
        UserMailer.feedback(self.sender,
                            self.user,
                            self.url,
                            self.event_date,
                            self.content).deliver
      when "feedback_req"
        UserMailer.feedback_req(self.sender,
                                self.user,
                                self.url,
                                self.event_date,
                                self.content).deliver
      when "message"
        UserMailer.usermessage(self.sender,
                               self.user,
                               self.url,
                               self.content).deliver
      when "friendship_req"
        UserMailer.friendship_req(self.sender,
                                  self.user,
                                  self.url,
                                  self.content).deliver
      when "friendship_app"
        UserMailer.friendship_app(self.sender,
                                  self.user,
                                  self.url).deliver
    end
  end

end
