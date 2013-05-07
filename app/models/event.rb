class Event < ActiveRecord::Base
  attr_accessible :partner, :partner_id, :book_id_user, :book_id_partner, :datetime

  ### Relationships
	belongs_to :user
  belongs_to :partner, class_name: 'User'
  has_many :notifications, as: :notificable, dependent: :destroy

  ### Validations
  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :partner_id, presence: true, if: Proc.new { |n| n.partner.nil? }
  validates :partner, presence: true, if: Proc.new { |n| n.partner_id.nil? }

	### Callbacks
  after_create :create_notifications_for_create
  before_destroy :create_notifications_for_destroy
  after_update :create_notifications_for_update

  def send_reminders
    self.partner.notifications.create(sender_id: self.user_id,
                                      ntype: "event_set_partner",
                                      notificable: self)
    self.user.notifications.create(sender_id: self.partner_id,
                                   ntype: "event_set_sender",
                                   notificable: self)    
  end

  private

  def create_notifications_for_create
    self.partner.notifications.create(sender_id: self.user_id,
                                   	  ntype: "event_set_partner",
                                   		notificable: self)
    self.user.notifications.create(sender_id: self.partner_id,
                                   ntype: "event_set_sender",
                                   notificable: self)
  end

  def create_notifications_for_destroy
    self.partner.notifications.create(sender_id: self.user_id,
                                      ntype: "event_cancel",
                                   		notificable: self)
    self.user.notifications.create(sender_id: self.user_id,
                                   ntype: "event_cancel",
                                   notificable: self)
  end

  def create_notifications_for_update
    self.partner.notifications.create(sender_id: self.user_id,
                                      ntype: "event_update",
                                   		notificable: self)
    self.user.notifications.create(sender_id: self.user_id,
                                   ntype: "event_update",
                                   notificable: self)
  end

  def create_notifications_for_remind
    self.partner.notifications.create(sender_id: self.user_id,
                                      ntype: "event_remind",
                                   		notificable: self)
    self.user.notifications.create(sender_id: self.user_id,
                                   ntype: "event_remind",
                                   notificable: self)
  end
end
