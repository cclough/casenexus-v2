class Comment < ActiveRecord::Base
  attr_accessible :user_id, :content, :rating

  belongs_to :commentable, polymorphic: true
  belongs_to :book
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  validates :rating, :numericality => { less_than_or_equal_to: 5 }
end