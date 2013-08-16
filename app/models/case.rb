class Case < ActiveRecord::Base

  attr_accessible :user, :user_id, :interviewer, :interviewer_id, :subject, :source, :book_id,
                  :interpersonal_comment, :businessanalytics_comment, :structure_comment,
                  :recommendation1, :recommendation2, :recommendation3,
                  :quantitativebasics, :problemsolving, :prioritisation, :sanitychecking,
                  :rapport, :articulation, :concision, :askingforinformation,
                  :approachupfront, :stickingtostructure, :announceschangedstructure, :pushingtoconclusion

  ### Relationships
  belongs_to :user
  belongs_to :interviewer, class_name: 'User'
  has_many :notifications, as: :notificable, dependent: :destroy
  has_many :points, as: :pointable, dependent: :destroy
  
  ### Callbacks
  after_create :create_notification
  after_create :create_points

  ### Validations
  validates :user_id, presence: true, if: Proc.new { |n| n.user.nil? }
  validates :user, presence: true, if: Proc.new { |n| n.user_id.nil? }
  validates :interviewer_id, presence: true, if: Proc.new { |c| c.interviewer.nil? }
  validates :interviewer, presence: true, if: Proc.new { |c| c.interviewer_id.nil? }

  validates :subject, length: { maximum: 500 }
  validates :source, length: { maximum: 100 }

  validates :quantitativebasics, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :problemsolving, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :prioritisation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :sanitychecking, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }


  validates :approachupfront, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :stickingtostructure, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :announceschangedstructure, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :pushingtoconclusion, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }

  validates :rapport, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :articulation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :concision, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :askingforinformation, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }

  validates :interpersonal_comment, length: { maximum: 500 }
  validates :businessanalytics_comment, length: { maximum: 500 }
  validates :structure_comment, length: { maximum: 500 }

  validates :recommendation1, length: { maximum: 200 }
  validates :recommendation2, length: { maximum: 200 }
  validates :recommendation3, length: { maximum: 200 }

  validate :is_a_friend
  validate :no_case_to_self

  ### Scopes

  # Scoped_search Gem
  scoped_search on: [:subject, :source, :recommendation1, :recommendation2, :recommendation3, :interpersonal_comment,
                     :businessanalytics_comment, :structure_comment]
  scoped_search in: :interviewer, on: [:first_name, :last_name]


  ### Outputs

  ## Micro

  # for Cases options_from_collection_for_select helper
  def interviewer_name
    interviewer.name
  end

  def businessanalytics_combined
    ((quantitativebasics + problemsolving + prioritisation + sanitychecking).to_f / 4).round(1)
  end

  def structure_combined
    ((approachupfront + stickingtostructure + announceschangedstructure + pushingtoconclusion).to_f / 4).round(1)
  end

  def interpersonal_combined
    ((askingforinformation + articulation + concision + rapport).to_f / 4).round(1)
  end

  def totalscore
    interpersonal_combined + businessanalytics_combined + structure_combined
  end

  def subject_trunc
    subject.truncate(40, separator: ' ')
  end

  def subject_trunc_menu
    subject.truncate(25, separator: ' ')
  end

  def to_s
    self.subject
  end

  ## Macro

  def criteria(num)
    case num
      when 0
        quantitativebasics
      when 1
        problemsolving
      when 2
        prioritisation
      when 3
        sanitychecking
      when 4
        approachupfront
      when 5
        stickingtostructure
      when 6
        announceschangedstructure
      when 7
        pushingtoconclusion
      when 8
        askingforinformation
      when 9
        articulation
      when 10
        concision
      when 11
        rapport
    end
  end

  def category(num)
    case num
      when 0
        businessanalytics_combined
      when 1
        structure_combined
      when 2
        interpersonal_combined
    end
  end


  def self.criteria_name(num)
    case num
      when 0
        "Quantitative basics"
      when 1
        "Problem solving"
      when 2
        "Prioritisation"
      when 3
        "Sanity Checking"
      when 4
        "Approach up front"
      when 5
        "Sticking to structure"
      when 6
        "Announces changed structure"
      when 7
        "Pushing to conclusion"
      when 8
        "Asking for information"
      when 9
        "Articulation"
      when 10
        "Concision"
      when 11
        "Rapport"
    end
  end

  def self.criteria_category(num)
    case num
      when 0..3
        "businessanalytics"
      when 4..7
        "structure"
      when 8..11
        "interpersonal"
    end
  end

  def self.category_name(num)
    case num
      when 0
        "Business Analytics"
      when 1
        "Structure"
      when 2
        "Interpersonal"
    end
  end

  def self.user_has_done_case(user,book_id)
    user.cases.map { |c| c.id }.include?(book_id)
  end

  def self.user_has_given_case(user,book_id)
    where(interviewer_id: user.id).map { |c| c.book_id }.include?(book_id)
  end

  ### Charts

  def cases_show_chart_radar_data_all
    "[{criteria: \"Quantitative basics\", score: "+quantitativebasics.to_s+"},
     {criteria: \"Problem-Solving\", score: "+problemsolving.to_s+"},
     {criteria: \"Prioritisation\", score: "+prioritisation.to_s+"},
     {criteria: \"Sanity-checking\", score: "+sanitychecking.to_s+"},

     {criteria: \"Make approach clear up front\", score: "+approachupfront.to_s+"},
     {criteria: \"Sticking to structure\", score: "+stickingtostructure.to_s+"},
     {criteria: \"Announces changed Structure\", score: "+announceschangedstructure.to_s+"},
     {criteria: \"Pusing to conclusion\", score: "+pushingtoconclusion.to_s+"},

     {criteria: \"Asking for information\", score: "+askingforinformation.to_s+"},
     {criteria: \"Articulation\", score: "+articulation.to_s+"},
     {criteria: \"Concision\", score: "+concision.to_s+"},
     {criteria: \"Rapport\", score: "+rapport.to_s+"}]"
  end

  def cases_show_chart_radar_data_combined
     "[{criteria: \"Business Analytics\", score: "+businessanalytics_combined.to_s+"},
     {criteria: \"Structure\", score: "+structure_combined.to_s+"},
     {criteria: \"Interpersonal\", score: "+interpersonal_combined.to_s+"}]"
  end


  def cases_show_category_chart_bar_data(category)

    case category
    when "businessanalytics"
      range = 0..3
    when "structure"
      range = 4..7
    when "interpersonal"
      range = 8..11
    end

    array = []
    range.each do |n|
      array << {:criteria => Case.criteria_name(n), :score => criteria(n)}
    end

    array.to_json

  end


  def self.cases_analysis_chart_radar_data_all(user, period)
    array = []

    12.times do |n|
      array << { criteria: self.criteria_name(n), 
                 all: self.criteria_av_user(user, user.cases.all.count, 0, n),
                 last: self.criteria_av_user(user, period, 0, n),
                 first: self.criteria_av_user(user, period, (user.cases.all.count - period), n) }
    end

    array.to_json
  end



  def self.cases_analysis_chart_radar_data_combined(user, period)
    array = []

    3.times do |n|
      array << { criteria: self.category_name(n), 
                 all: self.category_av_user(user, user.cases.all.count, 0, n),
                 last: self.category_av_user(user, period, 0, n),
                 first: self.category_av_user(user, period, (user.cases.all.count - period), n) }
    end

    array.to_json
  end

  
  def self.cases_analysis_table(user, period)

    # make hash
    hash = Hash.new
    12.times do |criteria_num|
      hash[criteria_num] = self.criteria_av_user(user, period, 0, criteria_num)
    end

    hash

  end



  def cases_show_table

    # make hash
    hash = Hash.new
    12.times do |criteria_num|
      hash[criteria_num] = self.criteria(criteria_num)
    end

    hash

  end







  def self.cases_analysis_chart_progress_data(user)
    cases_analysis_chart_progress_data = user.cases.order('created_at asc').map { |c|
      { id: c.id,
        date: c.created_at.strftime("%Y-%m-%d"),
        businessanalytics: c.businessanalytics_combined,
        structure: c.structure_combined,
        interpersonal: c.interpersonal_combined,
        totalscore: c.totalscore } }
  end





  def self.cases_analysis_chart_country_data(user)
    # Replace with SQL call as this will be expensive!
    # http://stackoverflow.com/questions/17243585/rails-pie-chart-for-countries-that-senders-of-a-users-messages-are-from
    interviewer_ids = user.notifications.collect(&:sender_id)

    country_count_hash = {}
    interviewer_ids.each do |interviewer_id|
      country = User.find(interviewer_id).country
      next unless country
      country_count_hash[country.name] ||= 0
      country_count_hash[country.name] += 1 
    end

    count_array = []
    country_count_hash.each do |key, value|
      count_array << {:country => key, :count => value}
    end

    count_array.to_json

  end


  def self.cases_analysis_chart_university_data(user)
    # Replace with SQL call as this will be expensive!
    # http://stackoverflow.com/questions/17243585/rails-pie-chart-for-countries-that-senders-of-a-users-messages-are-from
    interviewer_ids = user.notifications.collect(&:sender_id)

    university_count_hash = {}
    interviewer_ids.each do |interviewer_id|
      university = User.find(interviewer_id).university
      next unless university
      university_count_hash[university.name] ||= 0
      university_count_hash[university.name] += 1 
    end

    count_array = []
    university_count_hash.each do |key, value|
      count_array << {:university => key, :count => value}
    end

    count_array.to_json

  end






  ## Comments

  # marker_id to username conversion done in comment partial - saves repetition - may not be best tho
  def self.cases_analysis_comments_businessanalytics(user)
    user.cases.where("businessanalytics_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                                    created_at: m.created_at,
                                                                    businessanalytics_comment: m.businessanalytics_comment } }
  end

  def self.cases_analysis_comments_structure(user)
    user.cases.where("structure_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                            created_at: m.created_at,
                                                            structure_comment: m.structure_comment } }
  end

  def self.cases_analysis_comments_interpersonal(user)
    user.cases.where("interpersonal_comment <> ''").all { |m| { interviewer_id: m.interviewer_id,
                                                                created_at: m.created_at,
                                                                interpersonal_comment: m.interpersonal_comment } }
  end



  # STATISTICS

  def self.cases_analysis_stats_global(type)

    if Case.all.count > 0
      case type
        when "totalscore"
          (Case.all.map { |a| a.totalscore }.sum/Case.all.count).round(1) if Case.all.count > 0

        when "totalscore_top_quart"
          array = Case.all.map { |a| a.totalscore }
          percentile = 0.75
          array ? array.sort[((array.length * percentile).ceil)-1] : nil

        when "totalscore_bottom_quart"
          array = Case.all.map { |a| a.totalscore }
          percentile = 0.25
          array ? array.sort[((array.length * percentile).ceil)-1] : nil

      end
    else
      "-"
    end
  end

  def self.criteria_av_global(num)
    (Case.all.map { |a| a.criteria(num) }.sum/Case.all.count).round(2)
  end


  def self.criteria_av_user(user, period, offset, num)
    (user.cases.offset(offset.to_i).last(period.to_i).collect{|i| i.criteria(num) }.sum.to_f/period.to_i).round(1)
  end

  def self.category_av_user(user, period, offset, num)
    (user.cases.offset(offset.to_i).last(period.to_i).collect{|i| i.category(num) }.sum.to_f/period.to_i).round(1)
  end




  private

  def is_a_friend
    user = User.find(self.user_id)
    interviewer = User.find(self.interviewer_id)
    if !Friendship.friendship(user, interviewer)
      errors.add(:base, "You need to be case partners to send case feedback")
    end
  end

  def no_case_to_self
    unless self.user_id.blank?
      errors.add(:base, "You cannot send feedback to yourself") if self.user_id == self.interviewer_id
    end
  end

  def create_notification
    self.user.notifications.create(sender_id: self.interviewer_id,
                                   ntype: "feedback",
                                   content: self.subject,
                                   notificable: self)
  end

  def create_points
    # award receiving user some points
    self.user.points.create(method_id: 2,
                            pointable: self)

    # award sending user some points
    self.interviewer.points.create(method_id: 3,
                                   pointable: self)
  end

end
