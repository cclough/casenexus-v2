class Book < ActiveRecord::Base

  attr_accessible :btype, :tag_list, :title, :source_title, :desc, :university_id, :university, :author, :author_url, :url, :thumb, :chart_num, :difficulty, :average_rating

  # Associations
  belongs_to :university

  has_many :comments, as: :commentable, :after_add => :update_average_rating, :after_remove => :update_average_rating

  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings

  # Scoped_search Gem
  scoped_search on: [:title, :source_title, :author, :desc]
  scoped_search in: :university, on: [:name]


	class << self
	  def list_cases
	  	where("btype = 'case'")
	  end

	  def list_guides
	  	where("btype = 'guide' OR btype = 'link'")
	  end
	end

  def desc_trunc
    desc.to_s.truncate(180, separator: ' ')
  end

  def desc_trunc_very
    desc.to_s.truncate(50, separator: ' ')
  end

  def charts_file_name
    url.partition('.').first + "_charts.pdf"
  end

  def chart_num_in_words
    if chart_num == 0
      "No charts"
    else
      "Number of Charts: " + chart_num.to_s
    end
  end

  def update_average_rating(book=nil) #http://stackoverflow.com/questions/6008015/how-can-i-sort-my-records-by-average-rating
    s = self.comments.sum(:rating)
    c = self.comments.count
    self.update_attribute(:average_rating, c == 0 ? 0.0 : s / c.to_f)
  end
end
