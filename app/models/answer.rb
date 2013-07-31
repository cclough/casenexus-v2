class Answer < ActiveRecord::Base
  attr_accessible :content, :question_id

  # Associations
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable

  # Validations
  validates_presence_of :question_id
  validates_presence_of :user_id
  validates :content, presence: true, length: { maximum: 1000 } 

  # Voteable
  acts_as_voteable
end