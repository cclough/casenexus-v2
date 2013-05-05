class Event < ActiveRecord::Base
  attr_accessible :partner_id, :user_book_id, :partner_book_id, :datetime

belongs_to :user

  def partner
    User.find(self.partner_id)
  end

end
