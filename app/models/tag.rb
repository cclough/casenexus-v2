class Tag < ActiveRecord::Base
  attr_accessible :name, :category_id

  has_many :taggings, :dependent => :destroy
  has_many :taggables, :through => :taggings
  has_many :books, :through => :taggings, source: :taggable, source_type: 'Book'
  has_many :questions, :through => :taggings, source: :taggable, source_type: 'Question'
end
