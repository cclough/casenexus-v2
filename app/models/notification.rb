class Notification < ActiveRecord::Base
  attr_accessible :user, :user_id, :sender, :sender_id, :ntype, :content, :event_date, :read, :notificable_id, :notificable_type

  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :notificable, polymorphic: true

  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :sender_id, presence: true, if: Proc.new { |n| n.sender.nil? }
  validates :sender, presence: true, if: Proc.new { |n| n.sender_id.nil? }

  validates :content, length: { maximum: 500 }

  validates_presence_of :content, if: lambda { self.ntype == 'message' }
  # TODO: case shoudl be attached to notification by :notificable, that's where we get the date
  #validates_presence_of :content, :event_date, if: lambda { %w(feedback_req feedback).include?(self.ntype) }

  after_create :send_email

  def self.valid_types;%w(welcome message feedback feedback_req friendship_req friendship_app); end

  validates :ntype, presence: true, length: { maximum: 20 }, inclusion: { in: self.valid_types }

  class << self

    def readed
      where(read: true)
    end

    def unread
      where(read: false)
    end
  end

  # scoped_search :in => :user, :on => :first_name
  # scoped_search :in => :user, :on => :last_name
  scoped_search on: [:content]

  def read!
    update_attribute(:read, true)
  end

  def content_trunc
    content.truncate(35, :separator => ' ') unless (content == nil)
  end

  def url
    host = Rails.env == 'production' ? 'salty-crag-5200.herokuapp.com' : 'localhost:3000'

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
      where("(sender_id = ? and user_id = ?) or (sender_id = ? and user_id = ?)",
            from_id, to_id,
            to_id, from_id)
    end
  end

  private

  def send_email
    def after_create(notification)
      user_from = notification.sender

      breakpoint

      case notification.ntype
        when "welcome"
          UserMailer.welcome(notification.target,
                             notification.url).deliver
        when "feedback"
          UserMailer.feedback(user_from,
                              notification.target,
                              notification.url,
                              notification.event_date,
                              notification.content).deliver
        when "feedback_req"
          UserMailer.feedback_req(user_from,
                                  notification.target,
                                  notification.url,
                                  notification.event_date,
                                  notification.content).deliver
        when "message"
          UserMailer.usermessage(user_from,
                                 notification.target,
                                 notification.url,
                                 notification.content).deliver
        when "friendship_req"
          UserMailer.friendship_req(user_from,
                                    notification.target,
                                    notification.url,
                                    notification.content).deliver
        when "friendship_app"
          UserMailer.friendship_app(user_from,
                                    notification.target,
                                    notification.url).deliver
      end

    end
  end
end
