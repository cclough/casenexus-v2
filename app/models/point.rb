class Point < ActiveRecord::Base
  attr_accessible :pointable, :method_id

  ### Associations
  belongs_to :pointable, polymorphic: true
  belongs_to :user

  ### Validations
  validates :user_id, presence: true
  validates :method_id, presence: true
  validates_presence_of :pointable


  ### Callbacks
  after_create :create_notification



  private

  def create_notification
    case self.method_id
    when 1
      self.user.notifications.create(ntype: "points_feedback_rec",
                                     notificable: self)
    when 2
      self.user.notifications.create(ntype: "points_feedback_sent",
                                     notificable: self)
    when 3
      self.user.notifications.create(ntype: "points_vote",
                                     notificable: self)
    end
  end

end
