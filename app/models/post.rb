class Post < ActiveRecord::Base
  attr_accessible :content, :approved

  ### Associations
  belongs_to :user
  has_many :comments, as: :commentable

  ### Validations
  validates :content, presence: true, length: { maximum: 255 }
  validate :one_per_day

  ### Callbacks
  after_create :send_newpost_email_to_admin




  def content_trunc
    content.truncate(17, separator: ' ')
  end

  private
  
  def one_per_day
    if Post.where("user_id = ? AND DATE(created_at) = DATE(?)", self.user_id, Time.now).all.any?
      errors.add(:base, "You are limited to one post per day")
    end
  end

  def send_newpost_email_to_admin
    UserMailer.delay.newpost_to_admin(self)
  end

end
