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
  after_create :unlock_function

  def score
    case method_id
    when 1 # vote up
      5
    when 2 # receive feedback
      10
    when 3 # give feedback
      20
    end
  end

  def method
    case method_id
    when 1 # vote up
      "Vote up"
    when 2 # receive feedback
      "Did a case (received feedback)"
    when 3 # give feedback
      "Gave a case (sent feedback)"
    end
  end

  def date_fb
    if created_at > DateTime.now - 3.days
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")   
    end   
  end


  private

  def unlock_function

    # 5 points allows upvote
    if (self.user.points_tally >= 5) && !self.user.can_upvote?
      self.user.toggle!(:can_upvote)

      Notification.create!(user: self.user,
                           ntype: "points_unlock_voteup")

      puts "UNLOCK UP VOTE"
    end

    # 20 points allows upvote
    if (self.user.points_tally >= 20) && !self.user.can_downvote?
      self.user.toggle!(:can_downvote)

      Notification.create!(user: self.user,
                           ntype: "points_unlock_votedown")

      puts "UNLOCK DOWN VOTE"
    end

  end


end
