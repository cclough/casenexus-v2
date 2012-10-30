class Friendship < ActiveRecord::Base
  has_many :notifications, as: :notificable

  attr_accessible :user_id, :user, :friend_id, :friend, :invitation_message

  include Amistad::FriendshipModel

  after_create :create_notification_req

  validates :user_id, presence: true
  validates :friend_id, presence: true

  private

  def create_notification_req
    self.user.notifications.create(user_id: self.friend_id,
                                   sender_id: self.user.id,
                                   ntype: "friendship_req",
                                   content: self.invitation_message.to_s)
  end
end
