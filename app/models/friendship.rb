class Friendship < ActiveRecord::Base
  attr_accessible :user_id, :friend_id, :content

  # For friendship request message
  attr_accessor :content

  include Amistad::FriendshipModel
  
  ### Callbacks
  after_create :create_notification_req

  ### Validations
  validates :user_id, presence: true
  validates :friend_id, presence: true



  ### Methods




  private

    def create_notification_req
      self.user.notifications.create(user_id: self.friend_id,
                                     sender_id: self.user.id,
                                		 ntype: "friendship_req",
                                     content: @content)
    end

end
