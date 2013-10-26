class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :lat, :lng,
                  :skype, :email_admin, :email_users, :confirm_tac, :university, :university_id,
                  :invitation_code, :ip_address, :language_ids, :cases_external, :last_online_at, 
                  :time_zone, :degree_level, :linkedin, :completed

  attr_accessor :ip_address, :confirm_tac, :invitation_code

  ### Associations
  belongs_to :university
  belongs_to :country

  has_many :cases, dependent: :destroy
  has_many :cases_created, class_name: "Case", foreign_key: :interviewer_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notifications_sent, class_name: 'Notification', foreign_key: :sender_id, dependent: :destroy

  has_many :events, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :site_contacts, dependent: :destroy

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
  
  has_many :invitations, dependent: :destroy
  has_one :invitation, foreign_key: 'invited_id'



  ### Callbacks
  before_create :set_university
  before_create :suggest_username
  before_save { |user| user.email = user.email.downcase }
  before_create :send_newuser_email_to_admin
  after_create :update_invitation
  after_save :send_welcome
  after_validation :geocode, :reverse_geocode

  ### Validations

  validates_acceptance_of :confirm_tac

  # ON CREATE
  validate :validate_university_email, on: :create
  validate :validate_invitation, on: :create

  # ON UPDATE
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, on: :update
  validates :lng, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, on: :update
  validate :validate_not_too_close_to_another?, on: :update

  validates :username, presence: true, uniqueness: true, length: { maximum: 30 }, on: :update
  validates :linkedin, length: { maximum: 100 }
  validates :degree_level, presence: true, on: :update
  validates :skype, length: { maximum: 32 },
            allow_blank: true,
            on: :update
  validate :validate_has_languages?, on: :update
  validate :validate_cases_external?, on: :update

  ### Scopes
  # unused now - vincent work
  scope :not_friends, ->(user) {select('users.*, friends.id as fid').joins("left join friendships on users.id = friendships.friend_id and friendships.user_id = #{User.sanitize(user.id)} left join users as friends on friends.id = friendships.friend_id").where("friends.id is null and users.id != ?",user.id)}

  ### Other

  # Thumbs Up Gem
  # acts_as_voter

  # Scoped_search Gem
  scoped_search on: [:username]

  # Geocoder
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





  ### Micro

  def cases_per_week
    (cases.where(created_at: (4.week.ago)..(Time.now)).count / 4).round(1)
  end

  def username_trunc
    (username).truncate(15, separator: ' ')
  end

  def case_count_recd
    cases.count
  end

  def case_count_givn
    Case.where("interviewer_id = ?", self.id).all.count
  end

  def case_count_external
    if cases_external.blank?
      0
    else
      cases_external
    end
  end

  def degree_level_in_words
    case degree_level
    when 0
      "Undergrad/Masters"
    else
      "MBA"
    end
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

    def confirmed
      where("confirmed_at is not null")
    end

    def completed
      where(completed: true)
    end

    def active
      where(active: true)
    end

    def admin?
      admin == true
    end

    def not_admin
      where(admin: false)
    end

    def online_today
      where(last_online_at: (1.day.ago)..(Time.now))
    end

    def online_recently
      where(last_online_at: (1.hour.ago)..(Time.now))
    end

    def online_now
      where(last_online_at: (5.minutes.ago)..(Time.now))
    end

    ### Lists for filters

    def list_new
      completed.where(created_at: (1.day.ago)..(Time.now))
    end

    def list_local(user,include_current_user)
      if include_current_user == true
        user.nearbys(50).completed << user
      else
        user.nearbys(50).completed
      end
    end

    def list_online_today(user_to_exclude)
      where(active: true).where(["users.id <> ?",user_to_exclude.id]).completed.online_today
    end

    def list_online_now(user_to_exclude)
      where(active: true).where(["users.id <> ?",user_to_exclude.id]).completed.online_now
    end

    def list_all_excl_current(user)
      completed.where("id <> ?", user.id)
    end

    def list_language(language_id)
      if !language_id.blank? && language_id != "0"
        completed.joins(:languages_users).where(languages_users: {language_id: language_id})
      else
        completed
      end
    end

    def markers(users)
      users.map{ |m| { id: m.id, level: m.level, lat: m.lat, lng: m.lng } }
    end

    def markers_geojson(users)
      string = "["
      for user in users
        new_bit = "{
                    \"type\": \"Feature\",
                    \"geometry\": { \"type\": \"Point\", \"coordinates\": [#{user.lng},#{user.lat}] },
                    \"properties\": {
                      \"id\": \"#{user.id}\",
                      \"username\": \"#{user.username_trunc}\",
                      \"university_image\": \"#{user.university.image}\",
                      \"university_name\": \"#{user.university.name.upcase}\",
                      \"cases_recd\": \"#{user.case_count_recd}\",
                      \"cases_givn\": \"#{user.case_count_givn}\",
                      \"cases_ext\": \"#{user.cases_external}\",
                      \"icon\": {
                        \"iconUrl\": \"/assets/markers/marker_#{user.university.image}\",
                        \"iconSize\": [35, 57],
                        \"iconAnchor\": [17, 51]
                      }
                    }
                  },"
        string = string + new_bit
      end

      string = string.chop! + "]"
      string
    end
  end

  # Devise email overides (to enable async)
  def send_on_create_confirmation_instructions
    Devise::Mailer.delay.confirmation_instructions(self)
  end
  def send_reset_password_instructions
    Devise::Mailer.delay.reset_password_instructions(self)
  end
  def send_unlock_instructions
    Devise::Mailer.delay.unlock_instructions(self)
  end

  private

  def validate_invitation
    return if self.invitation_code == "BYPASS_CASENEXUS_INV"
    if self.invitation_code.blank?
      errors.add(:invitation_code, "not given")
    else
      if Invitation.where(code: self.invitation_code).exists?
        if Invitation.where("code = ? and invited_id is not null", self.invitation_code).exists?
          errors.add(:invitaiton_code, "already used.")
        end
      else
        errors.add(:invitation_code, "doesn't exist.")
      end
    end
  end

  def validate_has_languages?
    self.errors.add :base, "You must choose at least one language." if self.languages.blank?
  end


  def validate_not_too_close_to_another?
     self.errors.add :base, "Your marker is too close to someone else." if self.nearbys(0.008).count > 0
  end

  def validate_university_email
    unless self.email == "christian.clough@gmail.com" || self.email == "cclough@candesic.com" || self.email == "robin.clough@rady.ucsd.edu" || self.email == "gerald.templer@gmail.com"
      begin
        # finds database listed domain within string after at sign http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#25836
        domain = self.email.split("@")[1]
        errors.add(:base, "Sorry, casenexus is not yet available for your university") if University.all.none?{ |d| domain[d.domain] }
      rescue Exception => e
        errors.add(:base, "Sorry, casenexus is not yet available for your university")
      end
    end
  end

  def send_newuser_email_to_admin
    UserMailer.delay.newuser_to_admin(self)
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

  def suggest_username
    self.username = self.email.split("@")[0]
  end

  def set_university
    unless self.email == "christian.clough@gmail.com" || self.email == "cclough@candesic.com" || self.email == "robin.clough@rady.ucsd.edu" || self.email == "gerald.templer@gmail.com"
      domain = self.email.split("@")[1]
      # See SO Answer http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#comment40331_25836
      if found = University.find{ |d| domain[d.domain] } # Switch on enabled here eventually
        self.university = found
      else # not the important one
        errors.add(:base, "Sorry, casenexus is not yet available for your university")
      end
    else
      if self.email == "gerald.templer@gmail.com"
        self.university = University.find(2) # Set to oxford for certain people
      else
        self.university = University.find(1) # Set to cambridge if on exception list
      end
    end
  end

  def validate_cases_external?
    if self.cases_external.blank?
      self.cases_external = 0
    else
      errors.add(:cases_external, "must be a number between 0 and 500") unless cases_external.between?(0, 500)
    end
  end

end
