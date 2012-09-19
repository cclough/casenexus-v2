class Friendship < ActiveRecord::Base
  attr_accessible :user_id, :friend_id

  # For friendship request message
  attr_accessor :content

  include Amistad::FriendshipModel
  
  ### Callbacks
  after_create :create_notification_req
  after_update :create_notification_app

  private

    def create_notification_app
      self.user.notifications.create(sender_id: 1,
                                		 ntype: "friend_req",
                                     content: @content)
    end

end
