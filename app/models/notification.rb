class Notification < ActiveRecord::Base
  attr_accessible :user_id, :sender_id, :ntype, :content, 
									:case_id, :event_date, :read

  belongs_to :user

  validates :user_id, presence: true
  validates :sender_id, presence: true
  validates :ntype, presence: true, length: { maximum: 20 }

  validates :content, length: { maximum: 500 }

  ### Scopes

  # Read Scope
  scope :unread, where(read: false)


  ### Outputs

  ## Micro

  def sender
    User.find_by_id(sender_id)
  end

  def target
    User.find_by_id(user_id)
  end

  def self.header(user)
  	user.notifications.limit(5).order('id desc').reverse
  end


  def url

    host = "https://localhost:3000/"

    case ntype
    when "welcome"
      host
    when "message"
      host + "notifications/" + id.to_s  
    when "feedback"
      host + "cases/" + case_id.to_s
    when "feedback_req"
      host + "cases/new"
    end

  end

end
