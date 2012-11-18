class Case < ActiveRecord::Base

  attr_accessible :user, :user_id, :interviewer, :interviewer_id, :date, :subject, :source,
                  :interpersonal_comment, :businessanalytics_comment, :structure_comment,
                  :recommendation1, :recommendation2, :recommendation3,
                  :quantitativebasics, :problemsolving, :prioritisation, :sanitychecking,
                  :rapport, :articulation, :concision, :askingforinformation,
                  :approachupfront, :stickingtostructure, :announceschangedstructure, :pushingtoconclusion,
                  :roulette_token

  attr_accessor :roulette_token

  ### Relationships
  belongs_to :user
  belongs_to :interviewer, class_name: 'User'
  has_many :notifications, as: :notificable, dependent: :destroy

  ### Callbacks
  after_create :create_notification

  ### Validations
  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :interviewer_id, presence: true, if: Proc.new { |c| c.interviewer.nil? }
  validates :interviewer, presence: true, if: Proc.new { |c| c.interviewer_id.nil? }

  validates :date, presence: true

  validates :subject, presence: true, length: { maximum: 500 }
  validates :source, length: { maximum: 100 }

  validates :quantitativebasics, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :problemsolving, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :prioritisation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :sanitychecking, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  validates :rapport, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :articulation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :concision, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :askingforinformation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  validates :approachupfront, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :stickingtostructure, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :announceschangedstructure, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :pushingtoconclusion, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  validates :interpersonal_comment, length: { maximum: 500 }
  validates :businessanalytics_comment, length: { maximum: 500 }
  validates :structure_comment, length: { maximum: 500 }

  validates :recommendation1, length: { maximum: 200 }
  validates :recommendation2, length: { maximum: 200 }
  validates :recommendation3, length: { maximum: 200 }

  validate :friend_or_roulette_token
  validate :no_case_to_self

  ### Scopes

  # Scoped_search Gem
  scoped_search on: [:subject, :source, :recommendation1, :recommendation2, :recommendation3, :interpersonal_comment,
                     :businessanalytics_comment, :structure_comment]
  scoped_search in: :interviewer, on: [:first_name, :last_name]


  ### Outputs

  ## Micro

  def interpersonal_combined
    ((rapport + articulation + concision + askingforinformation).to_f / 4).round(1)
  end

  def businessanalytics_combined
    ((quantitativebasics + problemsolving + prioritisation + sanitychecking).to_f / 4).round(1)
  end

  def structure_combined
    ((approachupfront + stickingtostructure + announceschangedstructure + pushingtoconclusion).to_f / 4).round(1)
  end

  def totalscore
    interpersonal_combined + businessanalytics_combined + structure_combined
  end

  def subject_trunc
    subject.truncate(18, separator: ' ')
  end

  def to_s
    self.subject
  end

  ## Macro

  ### Charts

  def cases_show_chart_radar_data_all
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

  def cases_show_chart_radar_data_combined
     "[{criteria: \"Business Analytics\", score: "+businessanalytics_combined.to_s+"},
     {criteria: \"Interpersonal\", score: "+interpersonal_combined.to_s+"},
     {criteria: \"Structure\", score: "+structure_combined.to_s+"}]"
  end

  # case categories
  def cases_show_businessanalytics_chart_radar_data
    "[{criteria: \"Quantitative basics\", score: "+quantitativebasics.to_s+"},
     {criteria: \"Problem-Solving\", score: "+problemsolving.to_s+"},
     {criteria: \"Prioritisation\", score: "+prioritisation.to_s+"},
     {criteria: \"Sanity-checking\", score: "+sanitychecking.to_s+"}]"
  end

  def cases_show_interpersonal_chart_radar_data
    "[{criteria: \"Rapport\", score: "+rapport.to_s+"},
     {criteria: \"Articulation\", score: "+articulation.to_s+"},
     {criteria: \"Concision\", score: "+concision.to_s+"},
     {criteria: \"Asking for information\", score: "+askingforinformation.to_s+"}]"
  end

  def cases_show_structure_chart_radar_data
    "[{criteria: \"Make approach clear up front\", score: "+approachupfront.to_s+"},
     {criteria: \"Sticking to structure\", score: "+stickingtostructure.to_s+"},
     {criteria: \"Announces changed Structure\", score: "+announceschangedstructure.to_s+"},
     {criteria: \"Pusing to conclusion\", score: "+pushingtoconclusion.to_s+"}]"
  end


  def self.cases_analysis_chart_radar_data_all(user, count)
    # LAST 5: load scores into json for radar chart
    "[
      {criteria: \"Quantitative basics\", 
      all: " + (user.cases.order('id desc').collect(&:quantitativebasics).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:quantitativebasics).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:quantitativebasics).sum.to_f/count).to_s + "},
      {criteria: \"Problem-Solving\", 
      all: " + (user.cases.order('id desc').collect(&:problemsolving).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:problemsolving).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:problemsolving).sum.to_f/count).to_s + "},
      {criteria: \"Prioritisation\", 
      all: " + (user.cases.order('id desc').collect(&:prioritisation).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:prioritisation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:prioritisation).sum.to_f/count).to_s + "},
      {criteria: \"Sanity-checking\", 
      all: " + (user.cases.order('id desc').collect(&:sanitychecking).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:sanitychecking).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:sanitychecking).sum.to_f/count).to_s + "},
      {criteria: \"Rapport\", 
      all: " + (user.cases.order('id desc').collect(&:rapport).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:rapport).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:rapport).sum.to_f/count).to_s + "},
      {criteria: \"Articulation\", 
      all: " + (user.cases.order('id desc').collect(&:articulation).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:articulation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:articulation).sum.to_f/count).to_s + "},
      {criteria: \"Concision\", 
      all: " + (user.cases.order('id desc').collect(&:concision).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:concision).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:concision).sum.to_f/count).to_s + "},
      {criteria: \"Asking for information\", 
      all: " + (user.cases.order('id desc').collect(&:askingforinformation).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:askingforinformation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:askingforinformation).sum.to_f/count).to_s + "},
      {criteria: \"Approach up front\", 
      all: " + (user.cases.order('id desc').collect(&:approachupfront).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:approachupfront).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:approachupfront).sum.to_f/count).to_s + "},
      {criteria: \"Sticking to structure\", 
      all: " + (user.cases.order('id desc').collect(&:stickingtostructure).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:stickingtostructure).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:stickingtostructure).sum.to_f/count).to_s + "},
      {criteria: \"Announces structure change\", 
      all: " + (user.cases.order('id desc').collect(&:announceschangedstructure).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:announceschangedstructure).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:announceschangedstructure).sum.to_f/count).to_s + "},
      {criteria: \"Pusing to conclusion\", 
      all: " + (user.cases.order('id desc').collect(&:pushingtoconclusion).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:pushingtoconclusion).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:pushingtoconclusion).sum.to_f/count).to_s + "}
      ]"
  end

  def self.cases_analysis_chart_radar_data_combined(user, count)
    # LAST count: load scores into json for radar chart
    "[
      {criteria: \"Business Analytics\", 
      all: " + (user.cases.order('id desc').collect(&:businessanalytics_combined).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:businessanalytics_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:businessanalytics_combined).sum.to_f/count).to_s + "},
      {criteria: \"Interpersonal\", 
      all: " + (user.cases.order('id desc').collect(&:interpersonal_combined).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:interpersonal_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:interpersonal_combined).sum.to_f/count).to_s + "},
      {criteria: \"Structure\", 
      all: " + (user.cases.order('id desc').collect(&:structure_combined).sum.to_f/user.cases.all.count).to_s + ", 
      last: " + (user.cases.limit(count).order('id desc').collect(&:structure_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.limit(count).order('id asc').collect(&:structure_combined).sum.to_f/count).to_s + "}
      ]"
  end

  def self.cases_analysis_chart_progress_data(user)
    cases_analysis_chart_progress_data = user.cases.order('date asc').map { |c|
      { id: c.id,
        date: c.date.strftime("%Y-%m-%d"),
        interpersonal: c.interpersonal_combined,
        businessanalytics: c.businessanalytics_combined,
        structure: c.structure_combined,
        totalscore: c.totalscore } }
  end


  # Member show charts

  def self.users_index_user_feedback_chart_radar_data_all(user, interviewer, count)
    # LAST 5: load scores into json for radar chart
    "[
      {criteria: \"Quantitative basics\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:quantitativebasics).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:quantitativebasics).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:quantitativebasics).sum.to_f/count).to_s + "},
      {criteria: \"Problem-Solving\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:problemsolving).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:problemsolving).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:problemsolving).sum.to_f/count).to_s + "},
      {criteria: \"Prioritisation\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:prioritisation).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:prioritisation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:prioritisation).sum.to_f/count).to_s + "},
      {criteria: \"Sanity-checking\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:sanitychecking).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:sanitychecking).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:sanitychecking).sum.to_f/count).to_s + "},
      {criteria: \"Rapport\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:rapport).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:rapport).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:rapport).sum.to_f/count).to_s + "},
      {criteria: \"Articulation\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:articulation).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:articulation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:articulation).sum.to_f/count).to_s + "},
      {criteria: \"Concision\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:concision).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:concision).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:concision).sum.to_f/count).to_s + "},
      {criteria: \"Asking for information\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:askingforinformation).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:askingforinformation).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:askingforinformation).sum.to_f/count).to_s + "},
      {criteria: \"Approach up front\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:approachupfront).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:approachupfront).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:approachupfront).sum.to_f/count).to_s + "},
      {criteria: \"Sticking to structure\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:stickingtostructure).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:stickingtostructure).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:stickingtostructure).sum.to_f/count).to_s + "},
      {criteria: \"Announces structure change\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:announceschangedstructure).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:announceschangedstructure).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:announceschangedstructure).sum.to_f/count).to_s + "},
      {criteria: \"Pusing to conclusion\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:pushingtoconclusion).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:pushingtoconclusion).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:pushingtoconclusion).sum.to_f/count).to_s + "}
      ]"
  end

  def self.users_index_user_feedback_chart_radar_data_combined(user, interviewer, count)
    # LAST count: load scores into json for radar chart
    "[
      {criteria: \"Business Analytics\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:businessanalytics_combined).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:businessanalytics_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:businessanalytics_combined).sum.to_f/count).to_s + "},
      {criteria: \"Interpersonal\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:interpersonal_combined).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:interpersonal_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:interpersonal_combined).sum.to_f/count).to_s + "},
      {criteria: \"Structure\", 
      all: " + (user.cases.where("interviewer_id = #{interviewer}").order('id desc').collect(&:structure_combined).sum.to_f/user.cases.where("interviewer_id = #{interviewer}").count).to_s + ", 
      last: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id desc').collect(&:structure_combined).sum.to_f/count).to_s + ", 
      first: " + (user.cases.where("interviewer_id = #{interviewer}").limit(count).order('id asc').collect(&:structure_combined).sum.to_f/count).to_s + "}
      ]"
  end

  ## Comments

  # marker_id to username conversion done in comment partial - saves repetition - may not be best tho
  class << self
    def cases_analysis_comments_interpersonal(user)
      user.cases.where("interpersonal_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                                  created_at: m.created_at,
                                                                  interpersonal_comment: m.interpersonal_comment } }
    end

    def cases_analysis_comments_businessanalytics(user)
      user.cases.where("businessanalytics_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                                      created_at: m.created_at,
                                                                      businessanalytics_comment: m.businessanalytics_comment } }
    end

    def cases_analysis_comments_structure(user)
      user.cases.where("structure_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                              created_at: m.created_at,
                                                              structure_comment: m.structure_comment } }
    end
  end


  # STATISTICS

  class << self

    def cases_analysis_stats_uniques(user)
      user.cases.pluck(:sender_id).uniq.count
    end

    def cases_analysis_stats_casedate(user, type)

      if user.case_count < 1
        "-"
      else
        case type
          when "first"
            user.cases.all.last.date.strftime("%d %b '%y")
          when "last"
            user.cases.all.first.date.strftime("%d %b '%y")
        end
      end
      
    end

    def cases_analysis_stats_global(type)

      if Case.all.count > 0
        case type
          when "totalscore"
            (Case.all.map { |a| a.totalscore }.sum/Case.all.count).round(1) if Case.all.count > 0
          when "interpersonal"
            (Case.all.map { |a| a.interpersonal_combined }.sum/Case.all.count).round(1)
          when "businessanalytics"
            (Case.all.map { |a| a.businessanalytics_combined }.sum/Case.all.count).round(1)
          when "structure"
            (Case.all.map { |a| a.structure_combined }.sum/Case.all.count).round(1)
        end
      else
        "-"
      end
    end

    def cases_analysis_stats_user(user, type)
      if Case.all.count > 0
        begin
          case type
            when "totalscore"
              (user.cases.map { |a| a.totalscore }.sum/user.cases.count).round(1) if Case.all.count > 0
            when "interpersonal"
              (user.cases.map { |a| a.interpersonal_combined }.sum/user.cases.count).round(1)
            when "businessanalytics"
              (user.cases.map { |a| a.businessanalytics_combined }.sum/user.cases.count).round(1)
            when "structure"
              (user.cases.map { |a| a.structure_combined }.sum/user.cases.count).round(1)
          end
        rescue
          0
        end
      else
        "-"
      end
    end

  end

  private

  def friend_or_roulette_token
    user = User.find(self.user_id)
    interviewer = User.find(self.interviewer_id)
    if !Friendship.friendship(user, interviewer)
      if !self.roulette_token.blank? && self.roulette_token != user.roulette_token
        errors.add(:base, "You need to be case partner to send case feedback")
      end
    end
  end

  def no_case_to_self
    unless self.user_id.blank?
      errors.add(:base, "You cannot send feedback to yourself") if self.user_id == self.interviewer_id || self.roulette_token == self.interviewer.roulette_token
    end
  end

  def create_notification
    self.user.notifications.create(sender_id: self.interviewer_id,
                                   ntype: "feedback",
                                   content: self.subject,
                                   notificable: self,
                                   event_date: self.date)
  end

end
