class Question < ActiveRecord::Base
  include Taggable
  attr_accessible :content, :title, :view_count, :tag_list

  ### Associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings

  ### Validations
  validates_presence_of :user_id
  validates :title, presence: true, length: { maximum: 255 } 
  validates :content, presence: true, length: { maximum: 1000 } 
  # validates_presence_of :taggings

  ### Voting
  # acts_as_voteable


  ### Scoped_search Gem
  scoped_search on: [:content, :title]
  scoped_search in: :user, on: [:username]
  # WHAT ABOUT ANSWERS?




  ### Micro

  def content_trunc
    content.truncate(130, separator: ' ')
  end

  ### Macro

  def last_active_at
    if answers.count > 0
      answers.last.created_at
    else
      created_at
    end
  end

end
