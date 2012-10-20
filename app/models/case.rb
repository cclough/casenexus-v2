class Case < ActiveRecord::Base
  
  ### Mass assignables
  attr_accessible :user_id, :interviewer_id, :date, :subject, :source,
                  :recommendation1, :recommendation2, :recommendation3,
  								:structure_comment, :businessanalytics_comment, :interpersonal_comment,
                  :quantitativebasics, :problemsolving, :prioritisation, :sanitychecking,
                  :rapport, :articulation, :concision, :askingforinformation,
                  :approachupfront, :stickingtostructure, :announceschangedstructure, :pushingtoconclusion,
  				        :comment, :notes

  ### Relationships
  belongs_to :user

  ### Callbacks
  # after_create :create_notification

  ### Validations
  validates :user_id, presence: true
  validates :interviewer_id, presence: true
  validates :date, presence: true

  validates :subject, presence: true, length: { maximum: 500 }
  validates :source, length: { maximum: 100 }

  validates :quantitativebasics, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :problemsolving, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :prioritisation, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :sanitychecking, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

  validates :rapport, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :articulation, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :concision, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :askingforinformation, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

  validates :approachupfront, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :stickingtostructure, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :announceschangedstructure, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  validates :pushingtoconclusion, presence: true,
            :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

  validates :interpersonal_comment, length: { maximum: 500 }
  validates :businessanalytics_comment, length: { maximum: 500 }
  validates :structure_comment, length: { maximum: 500 }

  validates :recommendation1, length: { maximum: 200 }
  validates :recommendation2, length: { maximum: 200 }
  validates :recommendation3, length: { maximum: 200 }

  validates :notes, length: { maximum: 1000 }


  ### Scopes

  # Scoped_search Gem
  scoped_search :in => :user, :on => :first_name
  scoped_search :in => :user, :on => :last_name
  scoped_search :on => [:subject, :source, 
                        :recommendation1, :recommendation2, :recommendation3,
                        :interpersonal_comment, :businessanalytics_comment,
                        :structure_comment,
                        :notes]


  ### Outputs

  ## Micro

  def interpersonal_combined
    (rapport.to_i + articulation.to_i + concision.to_i + askingforinformation.to_i).round(1) / 4
  end

  def businessanalytics_combined
    (quantitativebasics.to_i + problemsolving.to_i + prioritisation.to_i + sanitychecking.to_i).round(1) / 4
  end

  def structure_combined
    (approachupfront.to_i + stickingtostructure.to_i + announceschangedstructure.to_i + pushingtoconclusion.to_i).round(1) / 4
  end


  def interviewer
    User.find_by_id(interviewer_id)
  end

  def totalscore
    interpersonal_combined + businessanalytics_combined + structure_combined
  end

  def subject_trunc
    subject.truncate(25, :separator => ' ')
  end


  ## Macro

  ### Charts

  def cases_show_chart_radar_data
    "[{criteria: \"Quantitative basics\", score: "+quantitativebasics.to_s+"},
     {criteria: \"Problem-Solving\", score: "+problemsolving.to_s+"},
     {criteria: \"Prioritisation\", score: "+prioritisation.to_s+"},
     {criteria: \"Sanity-checking\", score: "+sanitychecking.to_s+"},

     {criteria: \"Rapport\", score: "+rapport.to_s+"},
     {criteria: \"Articulation\", score: "+articulation.to_s+"},
     {criteria: \"Concision\", score: "+concision.to_s+"},
     {criteria: \"Asking for information\", score: "+askingforinformation.to_s+"},

     {criteria: \"Make approach clear up front\", score: "+approachupfront.to_s+"},
     {criteria: \"Sticking to structure\", score: "+stickingtostructure.to_s+"},
     {criteria: \"Announces changed Structure\", score: "+announceschangedstructure.to_s+"},
     {criteria: \"Pusing to conclusion\", score: "+pushingtoconclusion.to_s+"}]"
  end



  def self.cases_analysis_chart_radar_data(user)
    # LAST 5: load scores into json for radar chart
      "[
      {criteria: \"Quantitative basics\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:quantitativebasics).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:quantitativebasics).sum.to_f/5).to_s + "},
      {criteria: \"Problem-Solving\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:problemsolving).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:problemsolving).sum.to_f/5).to_s + "},
      {criteria: \"Prioritisation\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:prioritisation).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:prioritisation).sum.to_f/5).to_s + "},
      {criteria: \"Sanity-checking\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:sanitychecking).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:sanitychecking).sum.to_f/5).to_s + "},
      {criteria: \"Rapport\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:rapport).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:rapport).sum.to_f/5).to_s + "},
      {criteria: \"Articulation\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:articulation).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:articulation).sum.to_f/5).to_s + "},
      {criteria: \"Concision\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:concision).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:concision).sum.to_f/5).to_s + "},
      {criteria: \"Asking for information\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:askingforinformation).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:askingforinformation).sum.to_f/5).to_s + "},
      {criteria: \"Make approach clear up front\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:approachupfront).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:approachupfront).sum.to_f/5).to_s + "},
      {criteria: \"Sticking to structure\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:stickingtostructure).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:stickingtostructure).sum.to_f/5).to_s + "},
      {criteria: \"Announces changed Structure\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:announceschangedstructure).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:announceschangedstructure).sum.to_f/5).to_s + "},
      {criteria: \"Pusing to conclusion\", 
      last5: " + (user.cases.limit(5).order('id desc').collect(&:pushingtoconclusion).sum.to_f/5).to_s + ", 
      first5: " + (user.cases.limit(5).order('id asc').collect(&:pushingtoconclusion).sum.to_f/5).to_s + "}
      ]"
  end

  def self.cases_analysis_chart_progress_data(user)
    cases_analysis_chart_progress_data = user.cases.order('date asc').map {|c|
                                         { id: c.id,
                                         date: c.date.strftime("%Y-%m-%d"), 
                                         interpersonal: c.interpersonal_combined, 
                                         businessanalytics: c.businessanalytics_combined, 
                                         structure: c.structure_combined, 
                                         totalscore: c.totalscore } }
  end


  ## Comments

  # marker_id to username conversion done in comment partial - saves repetition - may not be best tho
  def self.cases_analysis_comments_interpersonal(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          interpersonal_comment: m.interpersonal_comment } }
  end

  def self.cases_analysis_comments_businessanalytics(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          businessanalytics_comment: m.businessanalytics_comment } }
  end

  def self.cases_analysis_comments_structure(user)
    user.cases.all {|m| { interviewer_id: m.interviewer_id, 
                          created_at: m.created_at, 
                          structure_comment: m.structure_comment } }
  end


  # STATISTICS

  def self.cases_analysis_stats_uniques(user)
    user.cases.pluck(:sender_id).uniq.count
  end

  def self.cases_analysis_stats_casedate(user, type)
    case type
    when "first"
      user.cases.all.last.date.strftime("%d %b '%y") unless user.casecount < 1
    when "last"
      user.cases.all.first.date.strftime("%d %b '%y") unless user.casecount < 1
    end
  end

  def self.cases_analysis_stats_averagescore(user)
    user.cases.map{ |a| a.totalscore }.sum/user.cases.count
  end


  def self.cases_analysis_stats_skill(user, type)

    if user.casecount > 0
      sums = { 'structure' => user.cases.average('structure').round(1),
               'businessanalytics' => user.cases.average('businessanalytics').round(1),
               'interpersonal' => user.cases.average('interpersonal').round(1) }

      case type
      when "weakest"
        sums.sort.map { |key, value| key + " (" + value.to_s + ")"}.first
      when "strongest"
        sums.sort.reverse.map { |key, value| key + " (" + value.to_s + ")"}.first
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
      when "interpersonal"
        Case.average(:interpersonal).round(2)
      when "businessanalytics"
        Case.average(:businessanalytics).round(2)
      when "structure"
        Case.average(:structure).round(2)
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
