class Visit < ActiveRecord::Base
  attr_accessible :visitor_id

  belongs_to :user

  after_create :destroy_user_visits_over_limit



  def visitor
    User.find(visitor_id)
  end
  
  def self.shouldnt_create?(user, visitor)
    visits = Visit.where(user_id: user.id, visitor_id: visitor.id)
    # already visited recently OR if self
    if (Time.now-5.hours..Time.now).cover?(visits.last.created_at) || (user == visitor)
     true
    else
      false
    end
  end


  private

  def destroy_user_visits_over_limit
    user = User.find(self.user_id)
    
    if user.visits.count > 10
      user.visits.order("created_at asc").first.delete
    end
  end
end
