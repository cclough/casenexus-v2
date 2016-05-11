class Invitation < ActiveRecord::Base
  attr_accessible :name, :email

  ### Associations
  belongs_to :user
  belongs_to :invited, class_name: 'User'

  ### Callbacks
  before_create :reset_activation_key
  after_create :send_invitation

  ### Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email,
                      :with => /(^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$)|^$/i,
                      :message => "must be a valid email address"
  validate :limit_invitations_per_user
  validate :validate_university_email, on: :create
  INVITATION_LIMIT = 20

  def reset_activation_key
    begin
      self.code = generate_activation_code
    end while Invitation.where(code: self.code).exists?
  end

  def send_invitation
    #UserMailer.delay.invitation(self)
  end

  #private

  def limit_invitations_per_user
    if self.user_id && self.user_id != 1
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

  def validate_university_email
    unless self.email == "christian.clough@gmail.com" || self.email == "cclough@candesic.com"
      begin
        # finds database listed domain within string after at sign http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#25836
        domain = self.email.split("@")[1]
        errors.add(:email, "not from a listed university") if University.all.none?{ |d| domain[d.domain] }
      rescue Exception => e
        errors.add(:email, "not from a listed university")
      end
    end
  end


end
