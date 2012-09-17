class User < ActiveRecord::Base

	### Mass assignables
  attr_accessible :first_name, :last_name, :email, 
  								:password, :password_confirmation, 
                  :lat, :lng, :status,
                  :education1, :education2, :education3,
                  :experience1, :experience2, :experience3,
                  :education1_from, :education1_to,
                  :education2_from, :education2_to,
                  :education3_from, :education3_to,
                  :experience1_from, :experience1_to,
                  :experience2_from, :experience2_to,
                  :experience3_from, :experience3_to,
                  :skype, :linkedin,
                  :email_admin,:email_users, :accepts_tandc

  ### Relationships
  has_many :cases
  has_many :notifications
  
  ### Bcrypt
  has_secure_password


  ### Callbacks
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  after_create :create_notification



  ### Validations
  # Names
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 30 }

  # Email (using Hartl RegEx)
  VALID_EM_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_SK_REGEX = /^[-a-z]+$/i
  validates :email, presence: true, format: { with: VALID_EM_REGEX },
  					uniqueness: { case_sensitive: true } 

  # Passwords
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # Status
  validates :status, presence: true, length: { maximum: 500, minimum: 50 }

  # Location
  validates :lat, presence: true
  validates :lng, presence: true


  # Skype & Linkedin
  validates :skype, length: { maximum: 32 },
            format: { with: VALID_SK_REGEX },
            allow_blank: true

  validates :linkedin, format: { with: VALID_EM_REGEX },
            allow_blank: true





  # Education
  validates :education1, presence: true

  # Accepts Terms and Conditions?
	validates :accepts_tandc, :acceptance => {:accept => true}





  ### Scopes

  # Scoped_search Gem
  scoped_search :on => [:first_name, :last_name, :status]

  # Approved Scopes
  scope :approved, where(approved: true)
  scope :unapproved, where(approved: false)



  ### GeoKit 
  
  acts_as_mappable :default_units => :kms,
                   :default_formula => :flat,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  ### Password Reset

  def send_password_reset
    create_password_reset_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver
  end

  def create_password_reset_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end


  ### Outputs

  ## Micro

  def name
    "#{first_name} #{last_name}"
  end

  def status_trunc
    status.truncate(35, :separator => ' ')
  end

  def casecount
    cases.all.count
  end


  ## Macro

  def self.markers
    markers = User.approved.map {|m| { id: m.id, lat: m.lat, lng: m.lng } }
  end

  # Filters
  def self.list_global
    User.approved.order('created_at desc')
  end

  def self.list_local(origin_lat, origin_lng)
    User.approved.within(100, origin: [origin_lat, origin_lng])
                 .order('created_at desc')
  end

  def self.list_rand
    User.approved.order("RANDOM()")
  end


  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

    def create_notification
      self.notifications.create(user_id: self.id,
                                sender_id: 1, # Admin user set in seeds.rb
                                ntype: "welcome")
    end

end
