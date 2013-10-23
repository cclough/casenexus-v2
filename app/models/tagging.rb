class Tagging < ActiveRecord::Base
  # attr_accessible :title, :body

  ### Associations
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  ### Scopes
  scope :books, where(taggable_type: 'Book')
  
end
