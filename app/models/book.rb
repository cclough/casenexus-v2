class Book < ActiveRecord::Base
  include Taggable
  attr_accessible :btype, :tag_list, :title, :source_title, :desc, :university_id, :university, :author, :author_url, :url, :thumb, :chart_num, :difficulty, :average_rating

  # Associations
  belongs_to :university

  has_many :comments, as: :commentable, :after_add => :update_average_rating, :after_remove => :update_average_rating

  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings

  # Scoped_search Gem
  scoped_search on: [:title, :source_title, :author, :desc]
  scoped_search in: :university, on: [:name]
  scope :tagged_on, ->(type_tag_ids, industry_tag_ids) {joins("LEFT OUTER JOIN taggings as tts ON tts.taggable_id = books.id AND tts.taggable_type = 'Book' LEFT OUTER JOIN taggings as idts ON idts.taggable_id = books.id AND idts.taggable_type = 'Book' WHERE tts.tag_id IN (#{type_tag_ids.join(',')}) AND idts.tag_id IN(#{industry_tag_ids.join(',')})")}#.where('taggings' => {tag_id: (type_tag_ids || [])}).joins(:taggings).where('taggings' => {tag_id: (industry_tag_ids || [])})}
  ### TAG STUFF - one day make a polymorphic (repeated in Book)
  # def self.tagged_with(name)
  #   Tag.find_by_name!(name).books
  # end

  # def self.tag_counts
  #   Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").
  #     joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  # end

  # def tag_list
  #   tags.map(&:name).join(", ")
  # end

  # def tag_list=(names)
  #   # names.pop #added pop and shift to remove first and last array items as chosen always including a blank field for unknown reason
  #   # names.shift
  #   self.tags = names.map do |n| # here a split(", ") is removed to enable chosen multiple input
  #     Tag.where(name: n.strip).first_or_create!
  #   end
  # end

  # def tag_list_ids=(ids)
  #   # names.pop #added pop and shift to remove first and last array items as chosen always including a blank field for unknown reason
  #   # names.shift
  #   self.tags = ids.map do |n| # here a split(", ") is removed to enable chosen multiple input
  #     Tag.find(n)
  #   end
  # end

  ### Micro

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

  ### Macro

	class << self
	  def list_cases
	  	where("btype = 'case'")
	  end

	  def list_guides
	  	where("btype = 'guide' OR btype = 'link'")
	  end
	end



  def update_average_rating(book=nil) #http://stackoverflow.com/questions/6008015/how-can-i-sort-my-records-by-average-rating
    s = self.comments.sum(:rating)
    c = self.comments.count
    self.update_attribute(:average_rating, c == 0 ? 0.0 : s / c.to_f)
  end
end
