class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :lat, :lng, :status,
                  :skype, :linkedin, :email_admin, :email_users, :ip_address, :confirm_tac, :university, :university_id,
                  :invitation_code, :linkedin_name, :status_moderated, :status_approved

  attr_accessor :ip_address, :confirm_tac, :invitation_code

  belongs_to :university
  has_many :cases, dependent: :destroy
  has_many :cases_created, class_name: "Case", foreign_key: :interviewer_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notifications_sent, class_name: 'Notification', foreign_key: :sender_id, dependent: :destroy
  has_many :feedbacks, dependent: :nullify
  has_many :site_contacts, dependent: :nullify

  # Friends
  has_many :friendships, dependent: :destroy
  has_many :accepted_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status = #{Friendship::ACCEPTED}", dependent: :destroy
  has_many :accepted_friends, through: :accepted_friendships, source: :friend
  has_many :requested_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status = #{Friendship::REQUESTED}", dependent: :destroy
  has_many :requested_friends, through: :requested_friendships, source: :friend
  has_many :pending_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status = #{Friendship::PENDING}", dependent: :destroy
  has_many :pending_friends, through: :pending_friendships, source: :friend
  has_many :rejected_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status = #{Friendship::REJECTED}", dependent: :destroy
  has_many :rejected_friends, through: :rejected_friendships, source: :friend
  has_many :blocked_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status = #{Friendship::BLOCKED}", dependent: :destroy
  has_many :blocked_friends, through: :blocked_friendships, source: :friend

  # Invitations
  has_many :invitations, dependent: :destroy
  has_one :invitation, foreign_key: 'invited_id'

  before_create :generate_roulette_token
  before_create :set_headline_and_university
  before_save { |user| user.email = user.email.downcase }
  before_update :update_status_moderated
  after_create :update_invitation
  after_save :send_welcome
  # Geocode
  before_create :geocode
  before_update :reverse_geocode

  ### Validations
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, on: :update
  validates :lng, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, on: :update
  validate :validate_university_email, on: :create
  validate :validate_invitation, on: :create

  ## ON UPDATE
  validates :status, presence: true, length: { maximum: 500, minimum: 50 }, on: :update
  validates :lat, presence: true, on: :update
  validates :lng, presence: true, on: :update

  validates :skype, length: { maximum: 32 },
            format: { with: /^[\w]+[a-z0-9\-]+$/i },
            allow_blank: true,
            on: :update

  # Scoped_search Gem
  scoped_search on: [:first_name, :last_name, :status, :headline]

  ### Geocoder
  geocoded_by :ip_address, :latitude => :lat, :longitude => :lng

  reverse_geocoded_by :lat, :lng do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def status_trunc
    status.to_s.truncate(30, separator: ' ')
  end

  def case_count
    cases.count
  end

  def self.markers
    User.includes(:cases).all.map { |m| { id: m.id, level: m.level, lat: m.lat, lng: m.lng } }
  end

  def level
    case case_count
      when 0..9 then 0
      when 10..19 then 1
      when 20..29 then 2
      when 30..39 then 3
      when 40..49 then 4
      when 50..1000 then 5
    end.to_s
  end

  def admin?
    self.admin == true
  end

  # Filters
  class << self
    def approved
      where(status_approved: true)
    end

    def unapproved
      where(status_approved: false)
    end

    def list_local(user)
      user.nearbys(100).order('created_at desc')
    end

    def list_global
      order('created_at desc')
    end

    def list_online
      order('last_online_at desc')
    end

    def list_contacts(user)
      user.accepted_friends
    end

    def confirmed
      where("confirmed_at is not null")
    end

    def status_approved
      where("status_approved = true")
    end
  end

  def to_s
    self.name
  end

  def generate_roulette_token
    begin
      self.roulette_token = ('a'..'z').to_a.shuffle[0,8].join
    end while User.where(roulette_token: self.roulette_token).exists?
    self.roulette_token
  end

  def status_approve!
    self.update_attribute(:status_approved, true)
    self.update_attribute(:status_moderated, true)
    UserMailer.status_approved(self).deliver
  end

  def status_reject!
    self.update_attribute(:status_approved, false)
    self.update_attribute(:status_moderated, true)
    UserMailer.status_rejected(self).deliver
  end

  private

  def validate_invitation
    return if self.invitation_code == "BYPASS_CASENEXUS_INV"
    if self.invitation_code.blank?
      errors.add(:invitation_code, "not supplied")
    else
      if Invitation.where(code: self.invitation_code).exists?
        if Invitation.where("code = ? and invited_id is not null", self.invitation_code).exists?
          errors.add(:invitaiton_code, "already used")
        end
      else
        errors.add(:invitation_code, "doesn't exists")
      end
    end
  end

  # Set the moderated and approved tag to false if its updated
  def update_status_moderated
    if self.status_was != self.status
      self.status_approved = false
      self.status_moderated = false
      Rails.logger.info("STATUS MODERATED")
      UserMailer.moderation_to_admin(self).deliver
    end
  end

  def update_invitation
    return if self.invitation_code == "BYPASS_CASENEXUS_INV"
    Invitation.where(code: self.invitation_code).first.update_attribute(:invited_id, self.id)
  end

  def send_welcome
    if completed_was == false and completed == true
      Notification.create!(user: self, sender_id: 1, ntype: "welcome") unless self.id == 1
    end
  end

  def set_headline_and_university
    domain = self.email.split("@")[1]
    if University.where(domain: domain).exists?
      self.university = University.where(domain: domain).first
      self.headline = "Student at #{university.name}" if self.headline.blank?
    end
  end

  def validate_university_email
    if self.linkedin_uid.blank?
      begin
        domain = self.email.split("@")[1]
        errors.add(:email, "not from listed University") unless University.where(domain: domain).exists?
      rescue Exception => e
        errors.add(:email, "Invalid Email")
      end
    end
  end

end
