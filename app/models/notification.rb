class Notification < ActiveRecord::Base
  attr_accessible :user, :user_id, :sender, :sender_id, :ntype, :content, :event_date, :read,
                  :notificable_id, :notificable_type, :notificable

  ### Relationships
  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :notificable, polymorphic: true

  ### Validations
  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :sender_id, presence: true, if: Proc.new { |n| n.sender.nil? }
  validates :sender, presence: true, if: Proc.new { |n| n.sender_id.nil? }
  validates :notificable_id, presence: true, if: Proc.new { |n| n.ntype == 'feedback' || 'event_set_partner' || 'event_set_sender' || 'event_cancel' || 'event_change' || 'event_remind'}
  validates :notificable_type, presence: true, if: Proc.new { |n| n.ntype == 'feedback' || 'event_set_partner' || 'event_set_sender' || 'event_cancel' || 'event_change' || 'event_remind' }
  validates :content, length: { maximum: 500 }

  validate :no_notification_to_self
  def self.valid_types;%w(welcome message feedback feedback_req friendship_req friendship_app event_set_partner event_set_sender event_cancel event_change event_remind); end
  # The two validations below must be after the line above!
  validates :ntype, presence: true, length: { maximum: 20 }, inclusion: { in: self.valid_types }
  validates :content, presence: true, if: lambda { self.ntype == 'message' }

  ### Callbacks
  after_create :send_email

  scoped_search in: :sender, on: [:first_name, :last_name]
  scoped_search on: [:content]

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


    # these were below before in a separate 'self' - can they stay here?
    def header(user)
      user.notifications.for_display.where(read: false).limit(5).order('created_at desc').reverse
    end

    def history(from_id, to_id)
      for_display.where("(sender_id = ? and user_id = ?) or (sender_id = ? and user_id = ?)",
                        from_id, to_id,
                        to_id, from_id).where(["ntype in (?)", ["message", "feedback", "feedback_req","friendship_req","friendship_app","event_set_partner","event_set_sender","event_cancel","event_change","event_remind"]])
    end

  end

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
      when "event_set_partner"
        "New case appointment"
      when "event_set_sender"
        "New case appointment"
      when "event_cancel"
        "Case appointment cancelled"
      when "event_change"
        "Case appointment updated"
      when "event_remind"
        "Case appointment reminder"
    end    
  end

  def url
    host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'

    case ntype
      when "welcome"
        Rails.application.routes.url_helpers.root_url(host: host)
      when "message"
        Rails.application.routes.url_helpers.notifications_url(id: id, host: host)
      when "feedback"
        Rails.application.routes.url_helpers.cases_url(id: notificable_id, host: host)
      when "feedback_req"
        Rails.application.routes.url_helpers.new_case_url(host: host, user_id: sender_id, date: event_date, subject: content.truncate(100))
      when "friendship_req"
        Rails.application.routes.url_helpers.notifications_url(host: host)
      when "friendship_app"
        Rails.application.routes.url_helpers.events_url(host: host, user_id: sender_id)
      when "event_set_partner"
        Rails.application.routes.url_helpers.events_url(host: host, id: notificable_id)
      when "event_set_sender"
        Rails.application.routes.url_helpers.events_url(host: host, id: notificable_id)
      when "event_cancel"
        Rails.application.routes.url_helpers.new_event_url(host: host)
      when "event_change"
        Rails.application.routes.url_helpers.events_url(host: host, id: notificable_id)
      when "event_remind"
        Rails.application.routes.url_helpers.events_url(host: host, id: notificable_id)
    end
  end


  private

  def no_notification_to_self
    if !user_id.blank?
      #exclude event notifications as they simulatenously send to self
      unless self.ntype == "event_set_partner" || "event_set_sender" || "event_cancel" || "event_change" || "event_remind"
        errors.add(:user_id, "Cannot send a notification to self") if self.user_id == self.sender_id
      end
    end
  end

  def send_email
    return if self.user.email_users == false
    case self.ntype
      when "welcome"
        UserMailer.welcome(self.user,
                           self.url,
                           self.title).deliver
      when "feedback"
        UserMailer.feedback(self.sender,
                            self.user,
                            self.url,
                            self.event_date,
                            self.content,
                            self.title).deliver
      when "feedback_req"
        UserMailer.feedback_req(self.sender,
                                self.user,
                                self.url,
                                self.event_date,
                                self.content,
                                self.title).deliver
      when "message"
        UserMailer.usermessage(self.sender,
                               self.user,
                               self.url,
                               self.content,
                               self.title).deliver
      when "friendship_req"
        UserMailer.friendship_req(self.sender,
                                  self.user,
                                  self.url,
                                  self.content,
                                  self.title).deliver
      when "friendship_app"
        UserMailer.friendship_app(self.sender,
                                  self.user,
                                  self.url,
                                  self.title).deliver
      when "event_set_partner"
        UserMailer.event_set_partner(self.sender,
                                     self.user,
                                     self.notificable_id,
                                     self.title,
                                     self.url).deliver
      when "event_set_sender"
        UserMailer.event_set_sender(self.user,
                                    self.notificable_id,
                                    self.title,
                                    self.url).deliver
      when "event_cancel"
        UserMailer.event_cancel(self.sender,
                                self.user,
                                self.notificable_id,
                                self.title,
                                self.url).deliver
      when "event_change"
        UserMailer.event_change(self.sender,
                                self.user,
                                self.notificable_id,
                                self.title,
                                self.url).deliver
      when "event_remind"
        UserMailer.event_remind(self.sender,
                                self.user,
                                self.notificable_id,
                                self.title,
                                self.url).deliver
    end
  end

end
