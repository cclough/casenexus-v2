class Case < ActiveRecord::Base
  attr_accessible :user_id, :interviewer_id, :date, :subject, :source, 
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



  ### Outputs

  ## Micro

  def interviewer
    User.find_by_id(interviewer_id)
  end

  def score
    structure + analytical + commercial + conclusion
  end

  ## Macro

  # Comments

  def comments
    @comments_plan = current_user.cases.all {|m| { marker_id: m.marker_id, created_at: m.created_at, plan_s: m.plan_s } }
    @comments_analytic = current_user.cases.all {|m| { marker_id: m.marker_id, analytic_s: m.analytic_s } }
    @comments_struc = current_user.cases.all {|m| { marker_id: m.marker_id, struc_s: m.struc_s } }
    @comments_conc = current_user.cases.all {|m| { marker_id: m.marker_id, conc_s: m.conc_s } }
  end


  ### Charts


  # Show

  def chart_show_radar
    "[{criteria: \"Structure\", score: "+structure.to_s+"},
     {criteria: \"Commercial\", score: "+commercial.to_s+"},
     {criteria: \"Conclusion\", score: "+conclusion.to_s+"},
     {criteria: \"Analytical\", score: "+analytical.to_s+"}]"
  end


  # Analysis

  def self.chart_analysis_radar(user)
    # LAST 5: load scores into json for radar chart
      "[
      {criteria: \"Structure\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:structure).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:structure).sum.to_f/5).to_s + "},
      {criteria: \"Commercial\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:commercial).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:commercial).sum.to_f/5).to_s + "},
      {criteria: \"Conclusion\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:conclusion).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:conclusion).sum.to_f/5).to_s + "},
      {criteria: \"Analytical\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:analytical).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:analytical).sum.to_f/5).to_s + "},
      ]"
  end

  def self.chart_analysis_progress(user)
    chart_analysis_progress = user.cases.order('date asc').map {|c|
                              { id: c.id,
                              date: c.date.strftime("%Y-%m-%d"), 
                              structure: c.structure, 
                              analytical: c.analytical, 
                              commercial: c.commercial, 
                              conclusion: c.conclusion } }
  end


end
