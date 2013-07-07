class Event < ActiveRecord::Base
  attr_accessible :user, :user_id, :partner, :partner_id, :book_id_usertoprepare, :book_id_partnertoprepare, :datetime

  ### Relationships
	belongs_to :user
  belongs_to :partner, class_name: 'User'
  has_many :notifications, as: :notificable

  ### Validations
  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  # validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :partner_id, presence: true, if: Proc.new { |n| n.partner.nil? }
  # validates :partner, presence: true, if: Proc.new { |n| n.partner_id.nil? }
  # validates :user_id,:partner_id, presence: true
  # validates :book_id_partnertoprepare, presence: true
  validates :datetime, presence: true, if: Proc.new { |n| n.datetime.nil? }


  def send_reminders
    # TBC
    # CALLED FROM SCHEDULER.RAKE
  end


  # Micro
  def book_partner
    Book.find(book_id_partnertoprepare)
  end

  def book_user
    Book.find(book_id_usertoprepare)
  end

  class << self

    def set(user, partner, datetime, book_id_usertoprepare, book_id_partnertoprepare)
      # ?if statement to check for duplicates/other on same day?
      transaction do
        notificable = create!(user: user, partner: partner, datetime: datetime, book_id_usertoprepare: book_id_usertoprepare, book_id_partnertoprepare: book_id_partnertoprepare)
        create_notification_for_create(user, partner, notificable, "event_set_sender")

        notificable = create!(user: partner, partner: user, datetime: datetime, book_id_usertoprepare: book_id_partnertoprepare, book_id_partnertoprepare: book_id_usertoprepare)
        create_notification_for_create(partner, user, notificable, "event_set_partner")
      end

      rescue ActiveRecord::RecordInvalid => invalid
        false
    end

    def cancel(user, partner)
      transaction do
        # sent to self so user, user
        create_notification_for_destroy(user, user, event(user, partner), "event_cancel") 
        destroy(event(user, partner))

        create_notification_for_destroy(partner, user, event(partner, user), "event_cancel")
        destroy(event(partner, user))
      end
    end

    def change(user, partner, datetime, book_id_usertoprepare, book_id_partnertoprepare)
      # ?if statement to check for duplicates/other on same day?
      transaction do
        event = event(user, partner)
        event.update_attributes!(datetime: datetime, book_id_usertoprepare: book_id_usertoprepare, book_id_partnertoprepare: book_id_partnertoprepare)
        event
        # sent to self so user, user
        create_notification_for_change(user, user, event, "event_change")

        event = event(partner, user)
        event.update_attributes!(datetime: datetime, book_id_usertoprepare: book_id_partnertoprepare, book_id_partnertoprepare: book_id_usertoprepare)
        event
        create_notification_for_change(partner, user, event, "event_change")
      end

      rescue ActiveRecord::RecordInvalid => invalid
        false
    end

    # Return a event based on the user and partner (used in e.g. cancel method)
    def event(user, partner)
      Event.where("user_id = ? and partner_id = ?", user.id, partner.id).first
    end

  end


  private

  class << self

    def create_notification_for_create(user, partner, notificable, ntype)
      Notification.create!(user: user,
                           sender: partner,
                           ntype: ntype,
                           notificable: notificable)
    end

    def create_notification_for_destroy(user, partner, notificable, ntype)
      Notification.create!(user: user,
                           sender: partner,
                           ntype: ntype,
                           notificable: notificable)
    end

    def create_notification_for_change(user, partner, notificable, ntype)
      Notification.create!(user: user,
                           sender: partner,
                           ntype: ntype,
                           notificable: notificable)
    end

  end
end
