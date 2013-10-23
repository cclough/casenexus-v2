class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user_id, :commentable, :commentable_type, :commentable_id

  ### Associations
  belongs_to :commentable, polymorphic: true
  belongs_to :book
  belongs_to :user
  
  ### Validations
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validates_presence_of :commentable
  validates :rating, presence: true, :if => :is_book?

  ### Voting
  acts_as_voteable

	def is_book?
	  self.commentable_type == "Book"
	end

end
