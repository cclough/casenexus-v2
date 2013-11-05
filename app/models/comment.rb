class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user_id, :commentable, :commentable_type, :commentable_id

  ### Associations
  belongs_to :commentable, polymorphic: true
  belongs_to :book
  belongs_to :user
  
  ### Validations
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000, minimum: 10 }
  validates_presence_of :commentable
  validates :rating, presence: true, :if => :is_book?

  # One comment per book
  validates :user_id, :uniqueness => { :scope => :commentable_id,
    :message => "you are limited to one review per item." }, :if => :is_book?

  ### Voting
  # acts_as_voteable

	def is_book?
	  self.commentable_type == "Book"
	end

  def date_fb
    if created_at > DateTime.now - 3.days
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")   
    end
  end

end
