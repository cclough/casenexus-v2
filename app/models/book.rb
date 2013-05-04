class Book < ActiveRecord::Base

  attr_accessible :btype, :title, :source_title, :desc, :university_id, :author, :author_url, :url, :thumb, :average_rating

  has_many :comments, as: :commentable, :after_add => :update_average_rating, :after_remove => :update_average_rating
  
  belongs_to :university

  # Scoped_search Gem
  scoped_search on: [:desc]

	class << self
	  def list_cases
	  	where("btype = 'case'")
	  end

	  def list_guides
	  	where("btype = 'guide' OR btype = 'link'")
	  end
	end

  def desc_trunc
    desc.to_s.truncate(200, separator: ' ')
  end

  def update_average_rating(book=nil) #http://stackoverflow.com/questions/6008015/how-can-i-sort-my-records-by-average-rating
    s = self.comments.sum(:rating)
    c = self.comments.count
    self.update_attribute(:average_rating, c == 0 ? 0.0 : s / c.to_f)
  end
end
