class Friendship < ActiveRecord::Base
  attr_accessible :user_id, :user, :friend_id, :friend, :invitation_message, :status, :accepted_at, :rejected_at, :blocked_at

  ### Associations
  has_many :notifications, as: :notificable, dependent: :destroy
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  ### Validations
  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true, inclusion: { in: [0, 1, 2, 3, 4] }
  validates :invitation_message, length: { maximum: 500 }

  # Status codes
  REQUESTED = 0         # friend_id REQUESTED user_id to accept invitation
  PENDING = 1           # user_id has a PENDING response to invitation from user_id
  ACCEPTED = 2          # user_id ACCEPTED invitation to friend_id so they are friends
  REJECTED = 3          # user_id REJECTED invitation to friend_id
  BLOCKED = 4           # user_id BLOCKED friend_id

  class << self

    # Return true if the users are (possibly pending) connections.
    def exist?(user, friend)
      not friendship(user, friend).nil?
    end

    # Return true if the users are friends
    def friends?(user, friend)
      accepted?(user, friend)
    end

    # Make a pending connection request.
    def request(user, friend, invitation_message = "")
      if user == friend or Friendship.exist?(user, friend)
        nil
      else
        transaction do
          create!(user: user, friend: friend, status: PENDING)
          friendship = create!(user: friend, friend: user, status: REQUESTED, invitation_message: invitation_message)
          # Now that the friendship was requested, send the message
          send_friend_request(user, friend, invitation_message, friendship)
        end
      end
    end

    # Accept a friendship request.
    def accept(user, friend)
      transaction do
        accepted_at = Time.now
        accept_one_side(user, friend, accepted_at)
        friendship = accept_one_side(friend, user, accepted_at)
        send_friend_accept(user, friend, friendship)
      end
    end

    # Reject a friendship request
    def reject(user, friend)
      transaction do
        rejected_at = Time.now
        reject_one_side(user, friend, rejected_at)
      end
    end

    # Block a friend
    def block(user, friend)
      transaction do
        blocked_at = Time.now
        block_one_side(user, friend, blocked_at)
      end
    end

    # Unblocks a friend
    def unblock(user, friend)
      transaction do
        unblock_one_side(user, friend)
      end
    end

    # Creates a friendship request and accept it
    def connect(user, friend)
      transaction do
        request(user, friend)
        accept(user, friend)
      end
      friendship(user, friend)
    end

    # Create a friendship connection without any notification
    def connect_without_notification(user, friend)
      unless user == friend or Friendship.exist?(user, friend)
        transaction do
          accepted_at = Time.now
          create(user: user, friend: friend, status: ACCEPTED, accepted_at: accepted_at)
          create(user: friend, friend: user, status: ACCEPTED, accepted_at: accepted_at)
        end
      end
      friendship(user, friend)
    end

    # Deletes a friendship or cancel a pending request
    def breakup(user, friend)
      transaction do
        destroy(friendship(user, friend))
        destroy(friendship(friend, user))
      end
    end


    # Return a friendship based on the user and friend.
    def friendship(user, friend)
      Friendship.where("user_id = ? and friend_id = ?", user.id, friend.id).first
    end

    # Tells if a user is connected to a friend
    def connected?(user, friend)
      exist?(user, friend) and accepted?(user, friend)
    end

    # Tells if a request was made
    def requested?(user, friend)
      exist?(user, friend) and friendship(user, friend).status == REQUESTED
    end

    # Tells if a friendship is pending
    def pending?(user, friend)
      exist?(user, friend) and friendship(user, friend).status == PENDING
    end

    # Tells if a request was accepted
    def accepted?(user, friend)
      exist?(user, friend) and friendship(user, friend).status == ACCEPTED
    end

    # Tells if a friendship is rejected
    def rejected?(user, friend)
      exist?(user, friend) and friendship(user, friend).status == REJECTED
    end

    # Tells if a friendship is blocked
    def blocked?(user, friend)
      exist?(user, friend) and friendship(user, friend).status == BLOCKED
    end

  end

  private

  class << self

    # Update the db with one side of an accepted connection request.
    def accept_one_side(user, friend, accepted_at)
      fs = friendship(user, friend)
      fs.update_attributes!(status: ACCEPTED, accepted_at: accepted_at)
      fs
    end

    # Update the db with one side of an rejected connection request.
    def reject_one_side(user, friend, rejected_at)
      fs = friendship(user, friend)
      fs.update_attributes!(status: REJECTED, rejected_at: rejected_at)
      fs
    end

    # Update the db with one side of a blocked connection request.
    def block_one_side(user, friend, blocked_at)
      fs = friendship(user, friend)
      fs.update_attributes!(status: BLOCKED, blocked_at: blocked_at)
      fs
    end

    # Update the db with one side of a blocked connection request.
    def unblock_one_side(user, friend)
      fs = friendship(user, friend)
      fs.update_attributes!(status: REQUESTED, blocked_at: nil)
      fs
    end

    # Notificates that a friendship has been requested
    def send_friend_request(sender, friend, invitation_message, friendship)
      Notification.create!(user_id: friend.id,
                           sender_id: sender.id,
                           ntype: "friendship_req",
                           content: invitation_message.to_s,
                           notificable: friendship)
    end

    # Notificates that a friendship has been accepted
    def send_friend_accept(sender, friend, friendship)
      Notification.create!(user_id: friend.id,
                           sender_id: sender.id,
                           ntype: "friendship_app",
                           notificable: friendship)
    end
  end
end
