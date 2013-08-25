class Tagging < ActiveRecord::Base
  # attr_accessible :title, :body

  scope :books, where(taggable_type: 'Book')
  belongs_to :taggable, polymorphic: true
  belongs_to :tag
  
end
