class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user_id, :commentable, :commentable_type, :commentable_id #last 2 can be removed!

  belongs_to :commentable, polymorphic: true
  belongs_to :book
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  validates :rating, presence: true, :if => :is_book?

	def is_book?
	  self.commentable_type == "Book"
	end
  
  acts_as_voteable
end
