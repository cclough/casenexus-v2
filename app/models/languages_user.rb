class LanguagesUser < ActiveRecord::Base
  
  ### Associations
  belongs_to :user
  belongs_to :language

  ### Validations
  validates_uniqueness_of :language_id, :scope => :user_id
end
