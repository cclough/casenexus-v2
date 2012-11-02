class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :lat, :lng, :status,
                  :skype, :linkedin, :email_admin, :email_users, :ip_address, :confirm_tac

  attr_accessor :ip_address, :confirm_tac

  has_many :cases
  has_many :notifications
  has_many :notifications_sent, class_name: 'Notification', foreign_key: :sender_id

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


  before_save { |user| user.email = user.email.downcase }

  before_create :generate_roulette_token
  after_create :send_welcome

  ### Validations
  validates :first_name, presence: true
  validates :last_name, presence: true

  ## ON UPDATE
  validates :status, presence: true, length: { maximum: 500, minimum: 50 }, on: :update
  validates :lat, presence: true, on: :update
  validates :lng, presence: true, on: :update

  validates :skype, length: { maximum: 32 },
            format: { with: /^[\w]+[a-z0-9\-]+$/i },
            allow_blank: true,
            on: :update

  # Scoped_search Gem
  scoped_search :on => [:first_name, :last_name, :status, :headline]

  ### Geocoder
  geocoded_by :ip_address, latitude: :lat, longitude: :lng

  reverse_geocoded_by :lat, :lng do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end

  ### GeoKit
  # NOTE: Geocoder and geokit-rails3 is a bad combination, we should stay with geokit-rail3 which encapsulates geocoder
  acts_as_mappable default_units: :kms,
                   default_formula: :flat,
                   distance_field_name: :distance,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  #after_validation :reverse_geocode
  #after_create :geocode

  def name
    "#{first_name} #{last_name}"
  end

  def status_trunc
    status.to_s.truncate(35, separator: ' ')
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

    def list_global
      order('created_at desc')
    end

    def list_local(lat, lng)
      within(100, origin: [lat, lng]).order('created_at desc')
    end

    def list_rand
      order("RANDOM()")
    end

    def list_contacts(user)
      user.accepted_friends
    end
  end

  def to_s
    self.name
  end

  private

  def send_welcome
    Notification.create(user: self, sender_id: 1, ntype: "welcome")
  end

  def generate_roulette_token
    begin
      self.roulette_token = ('a'..'z').to_a.shuffle[0,8].join
    end while User.where(roulette_token: self.roulette_token).exists?
  end

end
