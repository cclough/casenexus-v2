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
                  :email_admin,:email_users, :accepts_tandc, 

  ### Bcrypt
  has_secure_password


  ### Before Saves
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token


  ### Validations
  # Names
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 30 }

  # Email (using Hartl RegEx)
  VALID_EM_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EM_REGEX },
  					uniqueness: { case_sensitive: false } 

  # Passwords
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # Status
  validates :status, presence: true, length: { maximum: 500, minimum: 50 }

  # Location
  validates :lat, presence: true
  validates :lng, presence: true

  # Accepts Terms and Conditions?
	validates :accepts_tandc, :acceptance => {:accept => true}



  ### Scopes

  # Scoped_search Gem
  scoped_search :on => [:first_name, :last_name, :status]

  # Approved Scopes
  scope :approved, where(:approved => true)
  scope :unapproved, where(:approved => false)



  ### Outputs

  ## Micro
  # Name amalgamtion (not used that often - primarily just first name)
  def name
    "#{first_name} #{last_name}"
  end

  def status_trunc
    status.truncate(35, :separator => ' ')
  end



  ## Macro

  # Map marker for json conversion
  def self.markers
    markers = User.approved.map {|m| { id: m.id, lat: m.lat, lng: m.lng } }
  end





  ### Private Functions
  # function called above in before_saves to create session remember token
  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
