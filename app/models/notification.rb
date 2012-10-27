class Notification < ActiveRecord::Base
  attr_accessible :user_id, :sender_id, :ntype, :content, :notification_at, :read, :notificable_id, :notificable_type

  attr_accessor :sender

  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :notificable, polymorphic: true

  validates :user_id, presence: true
  validates :sender_id, presence: true
  validates :ntype, presence: true, length: { maximum: 20 }
  validates :content, length: { maximum: 500 }

  validates_presence_of :content, if: lambda { self.ntype == 'message' }
  validates_presence_of :content, :event_date, if: lambda { self.ntype == 'feedback_req' }
  validates_presence_of :content, :event_date, if: lambda { self.ntype == 'feedback' }

  after_create :send_email

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
    case ntype
      when "welcome"
        root_url
      when "message"
        notification_url(id)
      when "feedback"
        case_url(notificable_id)
      when "feedback_req"
        new_case_url
      when "friendship_req"
        friendship_url(sender_id)
      when "friendship_app"
        root_url
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
