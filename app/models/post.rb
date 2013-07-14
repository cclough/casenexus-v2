class Post < ActiveRecord::Base
  attr_accessible :content

  # Associations
  belongs_to :user
  has_many :comments, as: :commentable

  # Validations
  validates :content, presence: true, length: { maximum: 500 }

  def content_trunc
    content.truncate(17, separator: ' ')
  end

end
