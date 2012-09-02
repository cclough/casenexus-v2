class Case < ActiveRecord::Base
  attr_accessible :interviewer_id, :date, :subject, :source, 
  								:structure, :structure_comment,
  				        :analytical, :analytical_comment, 
  				        :commercial, :commercial_comment, 
  				        :conclusion, :conclusion_comment,
  				        :comment, :notes

  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :interviewer_id, presence: true
  validates :date, presence: true
  validates :subject, presence: true, length: { maximum: 500 }
  validates :source, length: { maximum: 100 }
  
  validates :structure, presence: true,
  					:numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :analytical, presence: true,
  					:numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :commercial, presence: true,
  					:numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :conclusion, presence: true,
  					:numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

  validates :structure_comment, length: { maximum: 500 }
  validates :analytical_comment, length: { maximum: 500 }
  validates :commercial_comment, length: { maximum: 500 }
  validates :conclusion_comment, length: { maximum: 500 }

  validates :comment, length: { maximum: 500 }
  validates :notes, length: { maximum: 1000 }


  # Scopes
  default_scope order: 'cases.created_at DESC'



  ### Outputs

  ## Micro

  def interviewer
    User.find_by_id(interviewer_id)
  end

  def score
    structure + analytical + commercial + conclusion
  end
end
