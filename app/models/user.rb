class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable,
         :confirmable,:rememberable

  attr_accessible :username, :email, :password, :password_confirmation, :lat, :lng,
                  :skype, :email_admin, :email_users, :confirm_tac, :university, :university_id,
                  :invitation_code, :ip_address, :language_ids, :cases_external, :last_online_at, 
                  :time_zone, :degree_level, :linkedin, :completed, :active, :confirmation_token, :confirmed_at,
                  :complete_page,:remember_me, :admin

  attr_accessor :ip_address, :confirm_tac, :invitation_code, :complete_page

  ### Associations
  belongs_to :university
  belongs_to :country

  has_many :cases, dependent: :destroy
  has_many :cases_givn, foreign_key: 'interviewer_id', class_name: 'Case'
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

  scope :case_count_recd_total_less_10, -> {joins("LEFT OUTER JOIN \"cases\" ON \"cases\".\"user_id\" = \"users\".\"id\" LEFT OUTER JOIN \"cases\" \"cases_givns_users\" ON \"cases_givns_users\".\"interviewer_id\" = \"users\".\"id\"").group('users.id, cases.id, cases_givns_users.id').having('(count(cases.id) + count(cases_givns_users.id) + cases_external) < 10')}
  scope :case_count_recd_total_great_10, -> {joins("LEFT OUTER JOIN \"cases\" ON \"cases\".\"user_id\" = \"users\".\"id\" LEFT OUTER JOIN \"cases\" \"cases_givns_users\" ON \"cases_givns_users\".\"interviewer_id\" = \"users\".\"id\"").group('users.id, cases.id, cases_givns_users.id').having('(count(cases.id) + count(cases_givns_users.id) + cases_external) >= 10')}



  ### Callbacks
  before_create :set_university
  before_create :suggest_username
  before_save { |user| user.email = user.email.downcase }
  
  after_create :send_newuser_email_to_admin # has to be after user has a username set
  after_save :send_welcome
  after_validation :geocode, :reverse_geocode

  ### Validations

  validates_acceptance_of :confirm_tac

  # ON CREATE
  validate :validate_university_email, on: :create

  # ON UPDATE

  # validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.zones_map { |m| m.name }, :message => "is not a valid Time Zone"
  
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


  #### Invitation validations - commented for launch
  # after_create :update_invitation
  # validate :validate_invitation, on: :create

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


  # Obfuscate - hide user_ids for calendar logins - http://stackoverflow.com/questions/9305036/how-do-i-obfuscate-the-ids-of-my-records-in-rails
  include ObfuscateHelper
  def obfuscated_id
    encrypt id
  end


  ### Micro

  def not_admin
    where(admin:false)
  end
  def cases_per_week
    (cases.where(created_at: (4.week.ago)..(Time.now)).count / 4).round(1)
  end

  def username_trunc
    (username).truncate(13)
  end

  def username_trunc_partnerslist
    (username).truncate(17)
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

  def distance_between(user)
    if distance_to(user).to_s.split(".")[0].size > 1
      distance_to(user).round(0)
    else
      distance_to(user).round(1)
    end
  end

  def case_count_recd_total
    case_count_recd + case_count_external
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

  def case_count_bracket_id
    if case_count_recd_total < 10
      0
    else
      1
    end
  end

  class << self

    def users_allowed_on_map
      completed.active#.not_admin
    end

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

    def users_in_same_bracket(user)
      if user.case_count_tital > 10
        self.where(cases>10)
      else

      end

    end

    ### Lists for filters

    def list_suggested(user)
      if user.nearbys(1).users_allowed_on_map.not_friends(user).count > 7
        if user.nearbys(1).users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).count > 7
          scope = user.nearbys(1).users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).order("cases_external desc").first(8)
        else
          scope = user.nearbys(1).users_allowed_on_map.not_friends(user).order("cases_external desc").first(8)
        end
      elsif user.nearbys(100).users_allowed_on_map.not_friends(user).count > 7
        if user.nearbys(100).users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).count > 7
          scope = user.nearbys(100).users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).order("cases_external desc").first(8)
        else
          scope = user.nearbys(100).users_allowed_on_map.not_friends(user).order("cases_external desc").first(8)
        end
      else
        if User.users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).count > 7
          scope = User.users_allowed_on_map.not_friends(user).list_by_experience(user.case_count_bracket_id).order("cases_external desc").first(8)
        else
          scope = User.order("cases_external desc").users_allowed_on_map.not_friends(user).first(8)
        end
      end
      scope

    end



    def list_new
      where(created_at: (1.day.ago)..(Time.now))
    end

    def list_local(user,include_current_user, with_case = false)
      if include_current_user == true
        # near([user.lat, user.lng], 50, :select => "cases.*, cases_givns_users.*")
        # user.nearbys(50, :select => (with_case ? "cases.*, cases_givns_users.*" : '')).completed << user
        user.nearbys(50) << user
      else
        # near([user.lat, user.lng], 50, :select => "cases.*, cases_givns_users.*")
        # user.nearbys(50, :select => (with_case ? "cases.*, cases_givns_users.*" : '')).completed
        user.nearbys(50)
      end
    end

    def list_online_today(user_to_exclude)
      where(active: true).where(["users.id <> ?",user_to_exclude.id]).online_today
    end

    def list_online_now(user_to_exclude)
      where(active: true).where(["users.id <> ?",user_to_exclude.id]).online_now
    end

    def list_all_excl_current(user)
      where(["users.id <> ?",user.id])
    end

    def list_language(language_id)
      if !language_id.blank? && language_id != "0"
        joins(:languages_users).where(languages_users: {language_id: language_id})
      else
        where(["users.id <> ?",0])
      end
    end

    def list_by_experience(choice_id)
      if choice_id == "0"
        case_count_recd_total_less_10
      elsif choice_id == "1"
        case_count_recd_total_great_10
      else
        where(["users.id <> ?",0])
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
                      \"index\": \"#{users.index(user)}\",
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

  def validate_has_languages?
    self.errors.add :base, "You must choose at least one language." if self.languages.blank?
  end

  def validate_not_too_close_to_another?
     self.errors.add :base, "Your marker is too close to someone else." if self.nearbys(0.008).count > 0
  end

  def validate_university_email
    unless self.email == "christian.clough@gmail.com" || self.email == "cclough@candesic.com" || self.email == "robin.clough@rady.ucsd.edu" || self.email == "gerald.templer@gmail.com" || self.email == "info@casenexus.com" || self.email == "shiota_kana@gsb.stanford.edu" || self.email == "alastairtwilley@gmail.com" || self.email == "dw.random@gmail.com" || self.email == "randylubin@gmail.com" || self.email == "nick@perspective.co.uk" || self.email == "b@benw.me" || self.email == "h.sperling@gmail.com" || self.email == "testing@testing.com" || self.email == "zstarke@gmail.com"
      begin
        # finds database listed domain within string after at sign http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#25836
        domain = self.email.split("@")[1]
        errors.add(:base, "Sorry, casenexus is not yet available for your university") unless University.all.any?{ |d| domain[d.domain] } || University.where( "domain2 <> ''" ).all.any?{ |d| domain[d.domain2] }
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

  def suggest_username
    self.username = self.email.split("@")[0]
  end

  def set_university
    unless self.email == "christian.clough@gmail.com" || self.email == "cclough@candesic.com" || self.email == "robin.clough@rady.ucsd.edu" || self.email == "gerald.templer@gmail.com" || self.email == "info@casenexus.com" || self.email == "shiota_kana@gsb.stanford.edu" || self.email == "alastairtwilley@gmail.com" || self.email == "dw.random@gmail.com" || self.email == "randylubin@gmail.com" || self.email == "nick@perspective.co.uk" || self.email == 'b@benw.me' || self.email == "h.sperling@gmail.com" || self.email == "testing@testing.com" || self.email == "zstarke@gmail.com"
      domain = self.email.split("@")[1]
      # See SO Answer http://codereview.stackexchange.com/questions/25814/ruby-check-if-email-address-contains-one-of-many-domains-from-a-table-ignoring/25836?noredirect=1#comment40331_25836
      
      if found = University.find{ |d| domain[d.domain] } || found = University.where( "domain2 <> ''" ).find{ |d| domain[d.domain2] } # Switch on enabled here eventually
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

  # def validate_invitation
  #   return if self.invitation_code == "BYPASS_CASENEXUS_INV"
  #   if self.invitation_code.blank?
  #     errors.add(:invitation_code, "not given")
  #   else
  #     if Invitation.where(code: self.invitation_code).exists?
  #       if Invitation.where("code = ? and invited_id is not null", self.invitation_code).exists?
  #         errors.add(:invitaiton_code, "already used.")
  #       end
  #     else
  #       errors.add(:invitation_code, "doesn't exist.")
  #     end
  #   end
  # end
  
  # def update_invitation
  #   return if self.invitation_code == "BYPASS_CASENEXUS_INV"
  #   Invitation.where(code: self.invitation_code).first.update_attribute(:invited_id, self.id)
  # end

end
