class User < ActiveRecord::Base
  has_merit

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :lat, :lng,
                  :skype, :email_admin, :email_users, :confirm_tac, :university, :university_id,
                  :invitation_code, :ip_address, :language_ids, :firm_ids, :channel_ids, :cases_external, :last_online_at, 
                  :time_zone, :subject_id, :degree_level

  attr_accessor :ip_address, :confirm_tac, :invitation_code

  # Belongs to
  belongs_to :university
  belongs_to :country
  belongs_to :subject

  # Has
  has_many :cases, dependent: :destroy
  has_many :cases_created, class_name: "Case", foreign_key: :interviewer_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notifications_sent, class_name: 'Notification', foreign_key: :sender_id, dependent: :destroy

  has_many :events
  has_many :posts
  has_many :comments
  has_many :site_contacts, dependent: :nullify

  has_many :channels_users, dependent: :destroy
  has_many :channels, :through => :channels_users

  has_many :firms_users, dependent: :destroy
  has_many :firms, :through => :firms_users
  has_many :languages_users, dependent: :destroy
  has_many :languages, :through => :languages_users

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
  
  # for vincent
  has_many :not_friendships, class_name: "Friendship", foreign_key: 'user_id', conditions: "friendships.status is NULL", dependent: :destroy
  has_many :not_friends, through: :not_friendships, source: :friend


  # Invitations
  has_many :invitations, dependent: :destroy
  has_one :invitation, foreign_key: 'invited_id'

  # Callbacks
  before_create :set_university
  before_save { |user| user.email = user.email.downcase }
  before_create :send_newuser_email_to_admin
  after_create :update_invitation
  after_create :subscribe_to_channels
  after_save :send_welcome

  # Geocode
  after_validation :geocode, :reverse_geocode

  ### Validations
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, on: :update
  validates :lng, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, on: :update
  validates_acceptance_of :confirm_tac

  validate :validate_university_email, on: :create
  validate :validate_invitation, on: :create



  ## ON UPDATE
  validates :lat, presence: true, on: :update
  validates :lng, presence: true, on: :update

  validates :degree_level, presence: true, on: :update
  validates :subject, presence: true, on: :update

  validates :skype, length: { maximum: 32 },
            format: { with: /^[\w]+[a-z0-9\-]+$/i },
            allow_blank: true,
            on: :update

  validate :validate_has_languages?, on: :update
  
  # Scoped_search Gem
  scoped_search on: [:first_name, :last_name]

  ### Geocoder
  geocoded_by :ip_address, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng do |obj, results|
    if geo = results.first
      obj.city = geo.city
      unless geo.country.blank?
        int_country = Country.find_by_name(geo.country)
        obj.country_id = int_country.id unless int_country == nil
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_trunc
    ("#{first_name} #{last_name}").truncate(17, separator: ' ')
  end

  def case_count_viewee
    cases.count
  end

  def case_count_viewer
    Case.where("interviewer_id = ?", self.id).all.count
  end

  def case_count_bracket
    # defines radar chart last 5 count
    case case_count_viewee
    when 0
      #signals to show 'you must do at least one case'
      0
    when 1..5
      1
    when 6..1000
      5
    end
  end

  def degree_level_in_words
    case degree_level
    when 0
      "Undergraduate/Masters"
    else
      "MBA"
    end
  end

  def level
    case case_count_viewee
      when 0..9 then 0
      when 10..19 then 1
      when 20..29 then 2
      when 30..39 then 3
      when 40..49 then 4
      when 50..1000 then 5
    end.to_s
  end

  def online_now?
    unless last_online_at.blank?
      true if last_online_at > DateTime.now - 5.minutes
    end
  end

  def online_earlier?
    unless last_online_at.blank?
      true if last_online_at > DateTime.now - 1.hour
    end
  end

  class << self

    # def active
    #   where(active: true)
    # end

    # def inactive
    #   where(active: false)
    # end

    def markers
      User.completed.not_admin.includes(:cases).all.map { |m| { id: m.id, level: m.level, lat: m.lat, lng: m.lng } }
    end

    def confirmed
      where("confirmed_at is not null")
    end

    def completed
      where("completed = true")
    end

    def admin?
      admin == true
    end

    def not_admin
      where("admin = false")
    end

    # used by list_online_today above
    def online_today
      where("last_online_at > ?", DateTime.now - 1.day)
    end

    def online_recently
      where("last_online_at > ?", DateTime.now - 1.hour)
    end

    ### Lists for filters

    # Simple Filters
    def list_global
      User.completed.not_admin
    end

    def list_local(user)
      user.nearbys(50).completed.not_admin.order('created_at desc')
    end

    def list_online_today
      completed.not_admin.online_today.order('last_online_at desc')
    end

    def list_online_recently_notfriends(user)
      user.not_friends.completed.online_recently.order('last_online_at desc')
    end

    # Pulldown Filters
    def list_language(language_id)
      if !language_id.blank?
        completed.not_admin.order('created_at desc').joins(:languages_users).where(languages_users: {language_id: language_id})
      else
        completed.not_admin.order('created_at desc')
      end
    end

    def list_firm(firm_id)
      if !firm_id.blank?
        completed.not_admin.order('created_at desc').joins(:firms_users).where(firms_users: {firm_id: firm_id})
      else
        completed.not_admin.order('created_at desc')
      end
    end

    def list_university(university_id)
      completed.not_admin.order('created_at desc').where(university_id: university_id)
    end

    def list_country(country_id)
      completed.not_admin.order('created_at desc').where(country_id: country_id)
    end


  end

  # def to_s
  #   self.name
  # end

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

  def validate_has_languages?
    self.errors.add :base, "You must choose at least one language." if self.languages.blank?
  end

  def validate_university_email
    begin
      # http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#25836
      domain = self.email.split("@")[1]
      errors.add(:email, "Sorry, no match found") if University.all.none?{ |d| domain[d.domain] }
    rescue Exception => e
      errors.add(:email, "not from a listed University")
    end
  end


  def send_newuser_email_to_admin
    UserMailer.newuser_to_admin(self).deliver
  end

  def send_welcome
    if completed_was == false and completed == true
      Notification.create!(user: self, sender_id: 1, ntype: "welcome") unless self.id == 1
    end
  end


  def update_invitation
    return if self.invitation_code == "BYPASS_CASENEXUS_INV"
    Invitation.where(code: self.invitation_code).first.update_attribute(:invited_id, self.id)
  end

  def set_university
    domain = self.email.split("@")[1]
    # See SO Answer http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#comment40331_25836
    if found = University.all.find{ |d| domain[d.domain] }
      self.university = found
    else
      errors.add(:email, "Sorry, no match found")
    end

  end

  def subscribe_to_channels
    self.channels << Channel.find_by_university_id(self.university.id)
    self.channels << Channel.find_by_country_id(self.country.id) unless self.country.blank?
  end


end
