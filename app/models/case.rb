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

  ## Macro

  # Comments

  def comments
    @comments_plan = current_user.cases.all {|m| { marker_id: m.marker_id, created_at: m.created_at, plan_s: m.plan_s } }
    @comments_analytic = current_user.cases.all {|m| { marker_id: m.marker_id, analytic_s: m.analytic_s } }
    @comments_struc = current_user.cases.all {|m| { marker_id: m.marker_id, struc_s: m.struc_s } }
    @comments_conc = current_user.cases.all {|m| { marker_id: m.marker_id, conc_s: m.conc_s } }
  end



  ### Charts

  def chart_case_radar
    chart_case_radar = "[{criteria: \"Structure\", score: "+structure.to_s+"},
                        {criteria: \"Analytical\", score: "+analytical.to_s+"},
                        {criteria: \"Commercial\", score: "+commercial.to_s+"},
                        {criteria: \"Conclusion\", score: "+conclusion.to_s+"}]"
  end


  ## Analysis


  # Radar
  def self.chart_analysis_radar_first5
    @userCases_first5 = @user.cases.limit(5).order('id asc')
  end
    
  def self.chart_analysis_radar_last5
    @userCases_last5 = @user.cases.limit(5).order('id desc')



  def chart_analysis_radar_structure
    @plan_avg = @userCases_last5.collect(&:plan).sum.to_f/@userCases_last5.length
  end

  def chart_analysis_radar_analytic
    @analytic_avg = @userCases_last5.collect(&:analytic).sum.to_f/@userCases_last5.length
  end

  def chart_analysis_radar_commercial
    @struc_avg = @userCases_last5.collect(&:struc).sum.to_f/@userCases_last5.length
  end

  def chart_analysis_radar_conclusion
    @conc_avg = @userCases_last5.collect(&:conc).sum.to_f/@userCases_last5.length
  end



  def self.chart_analysis_radar
    # LAST 5: load scores into json for radar chart
    @chartData_radar = "[{criteria: \"Plan\", last5: " + @plan_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
               {criteria: \"Analytical\", last5: " + @analytic_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
               {criteria: \"Structure\", last5: " + @struc_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "},
               {criteria: \"Conclusion\", last5: " + @conc_avg.to_s + ", first5: " + @plan_avg_first5.to_s + "}]"

  end


  # Progress

  def chart_analysis_progress

    respond_to do |format|
    format.html
    # this is model stuff ...defining an action in the model...?
    format.json { render json: current_user.cases.order('date asc').map {|c|
                { date: c.date.strftime("%Y-%m-%d"), plan: c.plan, analytic: c.analytic, 
                struc: c.struc, conc: c.conc } }}

    end
  
  end


end
