class Question < ActiveRecord::Base
  attr_accessible :content, :title, :view_count, :tag_list

  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings

  validates_presence_of :user_id
  validates :title, presence: true, length: { maximum: 255 } 
  validates :content, presence: true, length: { maximum: 500 } 

  acts_as_voteable




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

end
