class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited, class_name: 'User'

  attr_accessible :name, :email

  before_create :reset_activation_key
  after_create :send_invitation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validate :five_invitations_per_user

  validates_format_of :email,
                      :with => /(^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$)|^$/i,
                      :message => "must be a valid email address"

  INVITATION_LIMIT = 4

  def reset_activation_key
    begin
      self.code = generate_activation_code
    end while Invitation.where(code: self.code).exists?
  end

  def send_invitation
    UserMailer.invitation(self).deliver
  end

  #private

  def five_invitations_per_user
    if self.user_id
      if Invitation.where(user_id: self.user_id).count >= INVITATION_LIMIT
        errors.add(:base, "max limit per user is 5 invitations")
      end
    end
  end

  # Generates a random string from a set of easily readable characters
  def generate_activation_code(size = 8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end
end
