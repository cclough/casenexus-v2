class LanguagesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_uniqueness_of :language_id, :scope => :user_id
end
