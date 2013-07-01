class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user_id

  belongs_to :commentable, polymorphic: true
  belongs_to :book
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  validates :rating, presence: true, :if => :is_post?

def is_post?
  self.commentable_type == "Book"
end
  
end
