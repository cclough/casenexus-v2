class Visit < ActiveRecord::Base
  attr_accessible :visitor_id

  belongs_to :user

  after_create :destroy_user_visits_over_limit

  def self.create_new_visit_check?(user, visitor)
    visits = Visit.where(user_id: user.id, visitor_id: visitor.id)

    # check if self
    if user == visitor then false
      # can only perform check if mroe
      if visits.count > 0 then false
        # already visited recently?
        true if (Time.now-5.hours..Time.now).cover?(visits.last.created_at)
      end
    end

  end

  def visitor
    User.find(visitor_id)
  end

  private

  def destroy_user_visits_over_limit
    user = User.find(self.user_id)
    
    if user.visits.count > 10
      user.visits.first.delete
    end
  end
end
