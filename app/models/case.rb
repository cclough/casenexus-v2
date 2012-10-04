class Case < ActiveRecord::Base
  
  ### Mass assignables
  attr_accessible :user_id, :interviewer_id, :date, :subject, :source, 
  								:structure, :structure_comment,
  				        :analytical, :analytical_comment, 
  				        :commercial, :commercial_comment, 
  				        :conclusion, :conclusion_comment,
  				        :comment, :notes

  ### Relationships
  belongs_to :user

  ### Callbacks
  after_create :create_notification



  ### Validations
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


  ### Scopes

  # Scoped_search Gem
  scoped_search :in => :user, :on => :first_name
  scoped_search :in => :user, :on => :last_name
  scoped_search :on => [:subject, :source, 
                        :structure_comment, :analytical_comment,
                        :commercial_comment, :conclusion_comment,
                        :comment, :notes]


  ### Outputs

  ## Micro

  def interviewer
    User.find_by_id(interviewer_id)
  end

  def totalscore
    structure + analytical + commercial + conclusion
  end

  def subject_trunc
    subject.truncate(25, :separator => ' ')
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

  def cases_show_chart_radar_data
    "[{criteria: \"Structure\", score: "+structure.to_s+"},
     {criteria: \"Commercial\", score: "+commercial.to_s+"},
     {criteria: \"Conclusion\", score: "+conclusion.to_s+"},
     {criteria: \"Analytical\", score: "+analytical.to_s+"}]"
  end

  def self.cases_analysis_chart_radar_data(user)
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

  def self.cases_analysis_chart_progress_data(user)
    chart_analysis_progress = user.cases.order('date asc').map {|c|
                              { id: c.id,
                              date: c.date.strftime("%Y-%m-%d"), 
                              structure: c.structure, 
                              analytical: c.analytical, 
                              commercial: c.commercial, 
                              conclusion: c.conclusion,
                              totalscore: c.totalscore } }
  end



  ## Comments

  # marker_id to username conversion done in comment partial - saves repetition - may not be best tho
  def self.cases_analysis_comments_structure(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          structure_comment: m.structure_comment } }
  end

  def self.cases_analysis_comments_analytical(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          analytical_comment: m.analytical_comment } }
  end

  def self.cases_analysis_comments_commercial(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          commercial_comment: m.commercial_comment } }
  end

  def self.cases_analysis_comments_conclusion(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          conclusion_comment: m.conclusion_comment } }
  end



  # STATISTICS

  def self.cases_analysis_stats_uniques(user)
    user.cases.pluck(:sender_id).uniq.count
  end

  def self.cases_analysis_stats_casedate(user, type)
    case type
    when "first"
      user.cases.all.last.date.strftime("%d/%m/%Y") unless user.casecount < 1
    when "last"
      user.cases.all.first.date.strftime("%d/%m/%Y") unless user.casecount < 1
    end
  end

  def self.cases_analysis_stats_averagescore(user)
    user.cases.map{ |a| a.totalscore }.sum
  end

  def self.cases_analysis_stats_improvement(user, area)
    case area
    when "structure"
    when "analytical"
    when "commercial"
    when "conclusion"
    end
  end

  def self.cases_analysis_stats_skill(user, type)

    if user.casecount > 0
      sums = { 'Structure' => user.cases.average('structure').round(1),
               'Analytical' => user.cases.average('analytical').round(1),
               'Commercial' => user.cases.average('commercial').round(1),
               'Conclusion' => user.cases.average('conclusion').round(1) }

      case type
      when "weakest"
        sums.sort.reverse.map { |key, value| key + " (" + value.to_s + ")"}.first
      when "strongest"
        sums.sort.map { |key, value| key + " (" + value.to_s + ")"}.first
      end
    else
      "No data"
    end

  end

  def self.cases_analysis_stats_global(type)

    if Case.all.count > 0
      case type
      when "totalscore"
        (Case.all.map{ |a| a.totalscore }.sum/Case.all.count) if Case.all.count > 0
      when "structure"
        Case.average(:structure).round(2)
      when "analytical"
        Case.average(:analytical).round(2)
      when "commercial"
        Case.average(:commercial).round(2)
      when "conclusion"
        Case.average(:conclusion).round(2)
      end
    else
      "No data"
    end
  end


  private

    def create_notification
      self.user.notifications.create(sender_id: self.interviewer_id,
                                     ntype: "feedback",
                                     content: self.subject,
                                     case_id: self.id,
                                     event_date: self.date)
    end
    
end
