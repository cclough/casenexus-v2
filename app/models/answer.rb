class Answer < ActiveRecord::Base
  attr_accessible :content, :question_id

  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable

  validates_presence_of :question_id
  validates_presence_of :user_id
  validates :content, presence: true, length: { maximum: 500 } 

  acts_as_voteable
end
