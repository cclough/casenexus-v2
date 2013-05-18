class Language < ActiveRecord::Base
  attr_accessible :name, :country_code

  has_and_belongs_to_many :users

	# validate :has_users?

	# def has_users?
	#   self.errors.add :base, "Model must have some users." if self.languages.blank?
	# end

  after_save :validate_minimum_number_of_languages

	private

		# http://mattberther.com/2012/09/09/validating-habtm-relationships-with-rails-3x
	  def validate_minimum_number_of_users
	    if users.count < 1
	      errors.add(:users, "must have at least one user")
	      return false
	    end
	  end

end
