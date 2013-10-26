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
  validates :notificable_id, presence: true, if: Proc.new { |n| n.ntype == 'feedback'} # || 'event_set_partner' || 'event_set_sender' || 'event_cancel' || 'event_change' || 'event_remind'
  validates :notificable_type, presence: true, if: Proc.new { |n| n.ntype == 'feedback'}
  validates :content, length: { maximum: 500 }

  validate :no_notification_to_self
  def self.valid_types;%w(welcome message feedback friendship_req friendship_app 
                         event_set_partner event_set_sender 
                         event_change_partner event_change_sender 
                         event_cancel_partner event_cancel_sender 
                         event_remind_partner event_remind_sender); end
  # The two validations below must be after the line above!
  validates :ntype, presence: true, length: { maximum: 25 }, inclusion: { in: self.valid_types }
  validates :content, presence: true, if: lambda { self.ntype == 'message' }

  ### Callbacks
  after_create :send_email

  scoped_search in: :sender, on: [:username]
  scoped_search on: [:content]
  

  ### Micro
  def read!
    update_attribute(:read, true)
  end

  def content_trunc
    if self.ntype == "friendship_app"
      "Partner request accepted"
    else
      content.truncate(50, :separator => ' ') unless (content == nil)
    end
  end

  def title
    case ntype
      when "welcome"
        "Welcome"
      when "message"
        "Message"
      when "feedback"
        "New feedback"
      when "friendship_req"
        "Partner request"
      when "friendship_app"
        "Partner accepted"

      when "event_set_partner"
        "New case appointment"
      when "event_set_sender"
        "New case appointment"

      when "event_change_partner"
        "Case appointment updated"
      when "event_change_sender"
        "Case appointment updated"

      when "event_cancel_partner"
        "Case appointment cancelled"
      when "event_cancel_sender"
        "Case appointment cancelled"

      when "event_remind_partner"
        "Reminder: You have a case in 5 hours " + sender.username
      when "event_remind_sender"
        "Reminder: You have a case in 5 hours with " + user.username

    end    
  end

  def date_fb
    if created_at > DateTime.now - 3.days
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")   
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
      when "friendship_req"
        Rails.application.routes.url_helpers.notifications_url(host: host)
      when "friendship_app"
        Rails.application.routes.url_helpers.events_url(host: host, user_id: sender_id)


      when "event_set_partner"
        Rails.application.routes.url_helpers.events_url(host: host, event_id: notificable_id)
      when "event_set_sender"
        Rails.application.routes.url_helpers.events_url(host: host, event_id: notificable_id)

      when "event_change_partner"
        Rails.application.routes.url_helpers.events_url(host: host, event_id: notificable_id)
      when "event_change_sender"
        Rails.application.routes.url_helpers.events_url(host: host, event_id: notificable_id)

      when "event_cancel_partner"
        Rails.application.routes.url_helpers.events_url(host: host)
      when "event_cancel_sender"
        Rails.application.routes.url_helpers.events_url(host: host)


      when "event_remind_partner"
        "https://www.casenexus.com/profile?event_id=" + notificable_id.to_s
      when "event_remind_sender"
        "https://www.casenexus.com/profile?event_id=" + notificable_id.to_s


    end
  end

  ### Macro
  class << self

    def unread
      where(read: false)
    end

    def for_display
      where("ntype != 'welcome'")
    end

    def header(user)
      user.notifications.for_display.where(read: false).limit(5).order('created_at desc').reverse
    end

    def history(from_id, to_id)
      for_display.where("(sender_id = ? and user_id = ?) or (sender_id = ? and user_id = ?)",
                        from_id, to_id,
                        to_id, from_id).where(["ntype in (?)", ["message", "feedback", "friendship_req","friendship_app",
                                                                "event_set_partner","event_set_sender",
                                                                "event_change_partner","event_change_sender",
                                                                "event_cancel_partner","event_cancel_sender",
                                                                "event_remind_partner","event_remind_sender"]])
    end

  end

  private

  def no_notification_to_self
    if !user_id.blank?
      #exclude event notifications as they simulatenously send to self
      unless self.ntype == "event_set_partner" || "event_set_sender" || "event_cancel" || "event_change" || "event_remind"
        errors.add(:user_id, "No need to send a notification to yourself.") if self.user_id == self.sender_id
      end
    end
  end

  def send_email
    return if self.user.email_users == false
    case self.ntype
      when "welcome"
        UserMailer.delay.welcome(self.user,
                                 self.url,
                                 self.title)
      when "feedback"
        UserMailer.delay.feedback(self.sender,
                                  self.user,
                                  self.url,
                                  self.content,
                                  self.title)
      when "message"
        UserMailer.delay.usermessage(self.sender,
                               self.user,
                               self.url,
                               self.content,
                               self.title) unless self.user.online_now?
      when "friendship_req"
        UserMailer.delay.friendship_req(self.sender,
                                  self.user,
                                  self.url,
                                  self.content,
                                  self.title)
      when "friendship_app"
        UserMailer.delay.friendship_app(self.sender,
                                  self.user,
                                  self.url,
                                  self.title)
      when "event_set_partner"
        UserMailer.delay.event_setchangecancelremind_partner(self.sender,
                                                       self.user,
                                                       self.notificable_id,
                                                       self.title,
                                                       self.url,
                                                       self.ntype)
      when "event_set_sender"
        UserMailer.delay.event_setchangecancelremind_sender(self.user,
                                                      self.notificable_id,
                                                      self.title,
                                                      self.url,
                                                      self.ntype)
      when "event_change_partner"
        UserMailer.delay.event_setchangecancelremind_partner(self.sender,
                                                       self.user,
                                                       self.notificable_id,
                                                       self.title,
                                                       self.url,
                                                       self.ntype)
      when "event_change_sender"
        UserMailer.delay.event_setchangecancelremind_sender(self.user,
                                                      self.notificable_id,
                                                      self.title,
                                                      self.url,
                                                      self.ntype)
      when "event_cancel_partner"
        UserMailer.delay.event_setchangecancelremind_partner(self.sender,
                                                       self.user,
                                                       self.notificable_id,
                                                       self.title,
                                                       self.url,
                                                       self.ntype)
      when "event_cancel_sender"
        UserMailer.delay.event_setchangecancelremind_sender(self.user,
                                                      self.notificable_id,
                                                      self.title,
                                                      self.url,
                                                      self.ntype)
      when "event_remind_partner"
        UserMailer.delay.event_setchangecancelremind_partner(self.sender,
                                                       self.user,
                                                       self.notificable_id,
                                                       self.title,
                                                       self.url,
                                                       self.ntype)

      when "event_remind_sender"
        UserMailer.delay.event_setchangecancelremind_sender(self.user,
                                                      self.notificable_id,
                                                      self.title,
                                                      self.url,
                                                      self.ntype)
      end
  end




  def self.most_recent_for(user_id) # Vincent magic function
    sent = select("user_id as asso_id, MAX(id) as latest").where("(sender_id = ?)",
                        user_id).where("ntype <> ?","welcome").group('asso_id').order("latest")
    received = select("sender_id as asso_id, MAX(id) as latest").where("(user_id = ?)",
                    user_id).where("ntype <> ?","welcome").group('asso_id').order("latest")
    ids = (sent + received).sort_by(&:latest).reverse.uniq_by(&:asso_id).collect(&:latest)
    where(id: ids).order('created_at desc')
  end



end
