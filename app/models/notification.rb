class Notification < ActiveRecord::Base
  
  # NB An observer handles after_create email sending!

  attr_accessible :user_id, :sender_id, :ntype, :content, 
									:case_id, :event_date, :read

  attr_accessor :sender

  belongs_to :user

  validates :user_id, presence: true
  validates :sender_id, presence: true
  validates :ntype, presence: true, length: { maximum: 20 }

  validates :content, length: { maximum: 500 }

  # cool validation from: http://stackoverflow.com/questions/1673812/rails-validation-for-users-email-only-want-it-to-validate-when-a-user-signs-up
  validates_presence_of :content, :if => lambda {self.ntype == 'message'}
  validates_presence_of :content, :event_date, :if => lambda {self.ntype == 'feedback_req'}
  validates_presence_of :content, :event_date, :if => lambda {self.ntype == 'feedback'}

  ### Scopes

  # Read Scope
  scope :unread, where(read: false)


  # Scoped_search Gem

  # scoped_search :in => :user, :on => :first_name
  # scoped_search :in => :user, :on => :last_name
  scoped_search :on => [:content]

  ### Outputs

  ## Micro

  def sender
    User.find_by_id(sender_id)
  end

  def target
    User.find_by_id(user_id)
  end

  def content_trunc
    content.truncate(35, :separator => ' ') unless (content == nil)
  end

  def url

    host = "http://localhost:3000/"

    case ntype
    when "welcome"
      host
    when "message"
      host + "notifications/" + id.to_s  
    when "feedback"
      host + "cases/" + case_id.to_s
    when "feedback_req"
      host + "cases/new"
    when "friendship_req"
      host + "friendships/" + sender_id.to_s
    when "friendship_app"
      host
    end

  end

  ## Macro

  def self.header(user)
    user.notifications.where(read: false).limit(5).order('created_at desc').reverse
  end

  def self.history(from_id, to_id)
    notifications_from = Notification.where(sender_id: from_id, 
                                            user_id: to_id)
    notifications_to = Notification.where(sender_id: to_id,
                                          user_id: from_id)
    notifications_to + notifications_from
  end
end
