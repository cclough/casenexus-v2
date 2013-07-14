class Tagging < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :taggable, polymorphic: true
  belongs_to :tag
  
end
