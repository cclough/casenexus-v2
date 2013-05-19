class FirmsUser < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user
  belongs_to :firm

  validates_uniqueness_of :firm_id, :scope => :user_id
end
