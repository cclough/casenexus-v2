class Question < ActiveRecord::Base
  attr_accessible :content, :title, :view_count, :tag_list

  # Associations
  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings

  # Validations
  validates_presence_of :user_id
  validates :title, presence: true, length: { maximum: 255 } 
  validates :content, presence: true, length: { maximum: 1000 } 
  validates_presence_of :taggings

  # Voting
  acts_as_voteable


  # Scoped_search Gem
  scoped_search on: [:content, :title]
  scoped_search in: :user, on: [:first_name, :last_name]
  # ANSWERS?


  # TAG STUFF
  # PUT INTO CONTROLLER FOR POLYMORPHIC?
  def self.tagged_with(name)
    Tag.find_by_name!(name).taggables
  end

  def self.tag_counts
    Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end



  def content_trunc
    content.truncate(130, separator: ' ')
  end

  def last_active_at
    if answers.count > 0
      answers.last.created_at
    else
      created_at
    end
  end

end
