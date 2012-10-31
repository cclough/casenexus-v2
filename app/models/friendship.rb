class Friendship < ActiveRecord::Base
  has_many :notifications, as: :notificable

  attr_accessible :user_id, :user, :friend_id, :friend, :invitation_message

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true, inclusion: { in: [0..4] }

  after_create :send_notification

  # Status codes
  REQUESTED = 0
  PENDING = 1
  ACCEPTED = 2
  REJECTED = 3
  BLOCKED = 4


  class << self

    # Return true if the users are (possibly pending) connections.
    def exist?(user, friend)
      not friendship(user, friend).nil?
    end

    # Make a pending connection request.
    def request(user, friend, invitation_message = "")
      if user == friend or Friendship.exist?(user, friend)
        nil
      else
        transaction do
          create(user: user, friend: friend, status: PENDING, invitation_message: invitation_message)
          create(user: friend, friend: user, status: REQUESTED)
          # Now that the friendship was requested, send the message
          send_friend_request(friend, user, invitation_message)
        end
      end
    end

    # Accept a friendship request.
    def accept(user, friend)
      transaction do
        accepted_at = Time.now
        accept_one_side(user, friend, accepted_at)
        accept_one_side(friend, user, accepted_at)
        send_friend_accept(user, friend)
      end
    end

    # Reject a friendship request
    def reject(user, friend)
      transaction do
        rejected_at = Time.now
        reject_one_side(user, friend, rejected_at)
        reject_one_side(friend, user, rejected_at)
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
      friendship(user, friend).status == REQUESTED
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

  end

  private

  class << self
    # Update the db with one side of an accepted connection request.
    def accept_one_side(user, friend, accepted_at)
      fs = friendship(user, friend)
      fs.update_attributes!(status: ACCEPTED, accepted_at: accepted_at)
    end

    # Update the db with one side of an rejected connection request.
    def reject_one_side(user, friend, rejected_at)
      fs = friendship(user, friend)
      fs.update_attributes!(status: REJECTED, rejected_at: rejected_at)
    end
  end

  # Notificates that a friendship has been requested
  def send_friend_request(sender, friend, invitation_message)
    Notification.create!(user_id: friend.id,
                         sender_id: sender.id,
                         ntype: "friendship_req",
                         content: invitation_message.to_s)
  end

  # Notificates that a friendship has been accepted
  def send_friend_accept(sender, friend)
    Notification.create!(user_id: friend.id,
                         sender_id: sender.id,
                         ntype: "friendship_app")
  end
end
