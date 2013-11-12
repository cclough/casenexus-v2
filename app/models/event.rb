class Event < ActiveRecord::Base
  attr_accessible :user, :user_id, :partner, :partner_id, :book_id_usertoprepare, :book_id_partnertoprepare, :datetime

  ### Relationships
	belongs_to :user
  belongs_to :partner, class_name: 'User'
  has_many :notifications, as: :notificable, dependent: :destroy

  ### Validations
  validates :user_id, presence: true
  validates :partner_id, presence: true
  validates :datetime, presence: true


  class << self

    def next_appt_for(user)
      user.events.where("datetime > ?", Time.now).order("datetime asc").first
    end

    def time_diff_to_next_appt_for(user)
      next_appt = Event.next_appt_for(user)
      time_diff = Time.diff(Time.now, next_appt.datetime)

      if time_diff[:day] > 0
        strftime = '%y, %d, %H'
      elsif time_diff[:hour] > 5
        strftime = '%H'
      elsif time_diff[:hour] > 0
        strftime = '%H and %N'
      else
        strftime = '%N'        
      end

      Time.diff(Time.now.in_time_zone, next_appt.datetime.in_time_zone, strftime)      
    end

    def in_reminder_window
      where(datetime: (Time.now + 5.hours)..(Time.now + 6.hours))
    end

    def send_reminders
      Event.in_reminder_window.each do |notificable|
        create_notification(notificable.user, notificable.partner, notificable, "event_remind")
        puts "create reminder email..."
      end
    end

    def set(user, partner, datetime, book_id_usertoprepare, book_id_partnertoprepare)
      # ?if statement to check for duplicates/other on same day?
      transaction do
        notificable = create!(user: user, partner: partner, datetime: datetime, book_id_usertoprepare: book_id_usertoprepare, book_id_partnertoprepare: book_id_partnertoprepare)
        create_notification(user, partner, notificable, "event_set_sender")


        notificable = create!(user: partner, partner: user, datetime: datetime, book_id_usertoprepare: book_id_partnertoprepare, book_id_partnertoprepare: book_id_usertoprepare)
        # keep user and partner the same until the end of the chain ()
        create_notification(partner, user, notificable, "event_set_partner")
      end

      rescue ActiveRecord::RecordInvalid => invalid
        false
    end

    def change(user, partner, datetime, book_id_usertoprepare, book_id_partnertoprepare)
      # ?if statement to check for duplicates/other on same day?
      transaction do
        event = event(user, partner)
        event.update_attributes!(datetime: datetime, book_id_usertoprepare: book_id_usertoprepare, book_id_partnertoprepare: book_id_partnertoprepare)
        event
        # sent to self so user, user
        create_notification(user, user, event, "event_change_sender")

        event = event(partner, user)
        event.update_attributes!(datetime: datetime, book_id_usertoprepare: book_id_partnertoprepare, book_id_partnertoprepare: book_id_usertoprepare)
        event
        create_notification(partner, user, event, "event_change_partner")
      end

      rescue ActiveRecord::RecordInvalid => invalid
        false
    end

    def cancel(user, partner)
      transaction do
        # sent to self so user, user
        create_notification(user, partner, event(user, partner), "event_cancel_sender") 
        destroy(event(user, partner))

        create_notification(partner, user, event(partner, user), "event_cancel_partner")
        destroy(event(partner, user))
      end
    end

    # Return a event based on the user and partner (used in e.g. cancel method)
    def event(user, partner)
      Event.where("user_id = ? and partner_id = ?", user.id, partner.id).first
    end

  end


  private

  class << self

    def create_notification(user, partner, notificable, ntype)
      Notification.create!(user: user,
                           sender: partner,
                           ntype: ntype,
                           notificable: notificable)
    end

  end
end
