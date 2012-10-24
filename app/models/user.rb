class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :lat, :lng, :status,
                  :skype, :linkedin, :email_admin, :email_users, :ip_address, :confirm_tac

  attr_accessor :ip_address, :confirm_tac

  ### Relationships
  has_many :cases
  has_many :notifications

  ### Friendships Model
  include Amistad::FriendModel

  ### Callbacks
  before_save { |user| user.email = user.email.downcase }

  before_create :generate_roulette_token
  after_create :create_notification

  ### Validations
  validates :first_name, presence: true
  validates :last_name, presence: true

  ## ON UPDATE
  validates :status, presence: true, length: { maximum: 500, minimum: 50 }, on: :update
  validates :lat, presence: true, on: :update
  validates :lng, presence: true, on: :update

  validates :skype, length: { maximum: 32 },
            format: { with: /^[\w+\-.]+[-a-z]+$/i },
            allow_blank: true,
            on: :update

  # What exactly do you need from linkedin? You have the first name, last name, headline, company, profile url
  # and email, as far as I know, you don't have a unique user for linkedin
  #validates :linkedin_uid, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
  #          allow_blank: true,
  #          on: :update

  # Scoped_search Gem
  scoped_search :on => [:first_name, :last_name, :status, :headline]

  ### GeoKit
  acts_as_mappable default_units: :kms,
                   default_formula: :flat,
                   distance_field_name: :distance,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  ### Geocoder
  geocoded_by :ip_address, latitude: :lat, longitude: :lng

  reverse_geocoded_by :lat, :lng do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end

  after_create :geocode
  after_validation :reverse_geocode

  def name
    "#{first_name} #{last_name}"
  end

  def status_trunc
    status.truncate(35, separator: ' ')
  end

  def case_count
    cases.count
  end

  def self.markers
    User.all.map { |m| { id: m.id, lat: m.lat, lng: m.lng } }
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
      User.order('created_at desc')
    end

    def list_local(lat, lng)
      User.within(100, origin: [lat, lng]).order('created_at desc')
    end

    def list_rand
      User.order("RANDOM()")
    end

    def list_contacts(user)
      # Not neat, but works - http://stackoverflow.com/questions/12497037/rails-why-cant-i-run-paginate-on-current-user-friends/
      User.joins('INNER JOIN friendships ON friendships.friend_id = users.id').where(friendships: { user_id: user.id, pending: false, blocker_id: nil })
    end

    def create_using_linkedin(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.email = auth["info"]["email"]
        user.first_name = auth["info"]["first_name"]
        user.last_name = auth["info"]["last_name"]
        user.headline = auth["info"]["headline"]
      end
    end
  end

  private

  def create_notification
    self.notifications.create(user_id: self.id,
                              sender_id: 1, # Admin user set in seeds.rb
                              ntype: "welcome")
  end

  def generate_roulette_token
    begin
      self.roulette_token = ('a'..'z').to_a.shuffle[0,8].join
    end while User.where(roulette_token: self.roulette_token).exists?
  end

end
