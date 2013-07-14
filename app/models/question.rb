class Question < ActiveRecord::Base
  attr_accessible :content, :title, :view_count

  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  
  validates_presence_of :user_id
  validates :title, presence: true, length: { maximum: 255 } 
  validates :content, presence: true, length: { maximum: 500 } 

  acts_as_voteable
end
