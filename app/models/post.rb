class Post < ActiveRecord::Base
  attr_accessible :content, :approved

  ### Associations
  belongs_to :user
  has_many :comments, as: :commentable

  ### Validations
  validates :content, presence: true, length: { maximum: 255 }
  validate :one_per_day, on: :create

  ### Callbacks
  after_create :send_newpost_email_to_admin

  def date_fb
    if created_at > DateTime.now - 3.days
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")
    end
  end

  def prev
    if Post.where("approved", true).where("created_at < ?", created_at).count == 0
      nil
    else
      Post.where("approved", true).where("created_at < ?", created_at).last
    end
  end

  def next
    if Post.where("approved", true).where("created_at > ?", created_at).count == 0
      nil
    else
      Post.where("approved", true).where("created_at > ?", created_at).first
    end
  end

  def self.approved
    where(approved: true)
  end

  private

  def one_per_day
    if Post.where("user_id = ? AND DATE(created_at) = DATE(?)", self.user_id, Time.now).all.any?
      errors.add(:base, "You are limited to one post per day.")
    end
  end

  def send_newpost_email_to_admin
    # UserMailer.delay.newpost_to_admin(self)
  end

end
