class Case < ActiveRecord::Base

  attr_accessible :user, :user_id, :interviewer, :interviewer_id, :subject, :source, :book_id,
                  :main_comment, :created_at,
                  :recommendation1, :recommendation2, :recommendation3,
                  :quantitativebasics, :problemsolving, :prioritisation, :sanitychecking,
                  :rapport, :articulation, :concision, :askingforinformation,
                  :approachupfront, :stickingtostructure, :announceschangedstructure, :pushingtoconclusion

  ### Relationships
  belongs_to :user
  belongs_to :interviewer, class_name: 'User'
  has_many :notifications, as: :notificable, dependent: :destroy
  has_one :book

  ### Callbacks
  after_create :create_notification

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

  validates :main_comment, length: { maximum: 1000 }

  validates :recommendation1, length: { maximum: 200 }
  validates :recommendation2, length: { maximum: 200 }
  validates :recommendation3, length: { maximum: 200 }

  validate :is_a_friend
  validate :no_case_to_self

  ### Scopes

  # Scoped_search Gem
  scoped_search on: [:subject, :source, :recommendation1, :recommendation2, :recommendation3, 
                     :main_comment]
  scoped_search in: :interviewer, on: [:username]


  ### Outputs

  ## Micro

  # for Cases options_from_collection_for_select helper
  def interviewer_name
    interviewer.username
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

  def totalscore_percentage
    (totalscore / 15) * 100
  end

  def subject_trunc
    subject.truncate(40, separator: ' ')
  end

  def subject_trunc_menu
    subject.truncate(30, separator: ' ')
  end

  def date_fb
    if created_at > DateTime.now - 3.days
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")   
    end
  end

  def read!
    update_attribute(:read, true)
  end
  
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

  ## Macro

  def next
    if user.cases.where("id > ?", id).count == 0
      user.cases.order("id ASC").first
    else
      user.cases.where("id > ?", id).order("id ASC").first
    end
  end

  def prev
    if user.cases.where("id < ?", id).count == 0
      user.cases.order("id DESC").first
    else
      user.cases.where("id < ?", id).order("id DESC").first
    end
  end

  def self.unread
    where(read: false)
  end

  def self.user_has_done_case(user,book_id) # event modal book lists
    user.cases.map { |c| c.id }.include?(book_id)
  end

  def self.user_has_given_case(user,book_id) # event modal book lists
    where(interviewer_id: user.id).map { |c| c.book_id }.include?(book_id)
  end


  ### Charts

  def self.user_activity_chart(user,view)
    options = {}
    options[:type] ||= :line
    options[:bgcolor] ||= "00000000"
    options[:chart_color] ||= "336699"
    options[:area_color] ||= "DFEBFF"
    options[:line_color] ||= "0077CC"
    options[:line_width] ||= "2"
    max_data_point = 3

    if view == "profile"
      options[:size] ||= "100x30"
    elsif view == "map"
      options[:size] ||= "365x78"
      options[:gridlines] ||= "chg=5,30,1,1,0,0&"
    end

    # create activity string
    from = Time.now - 3.months
    to = Time.now
    tmp = from
    array = []
    begin
       tmp += 1.week
       array << user.cases.where("created_at BETWEEN ? AND ?", tmp, tmp + 1.week).count
    end while tmp <= to

    activity_str = array.map(&:inspect).join(',')

    return "https://chart.googleapis.com/chart?#{options[:gridlines]}chs=#{options[:size]}&cht=ls&chco=#{options[:line_color]}&chm=B,#{options[:area_color]},0,0,0&chd=t:#{activity_str}&chds=0,#{max_data_point}&chf=bg,s,#{options[:bgcolor]}&"

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
    if user.cases.count >= 2
      cases_analysis_chart_progress_data = user.cases.order('created_at asc').map { |c|
        { id: c.id,
          date: c.created_at.strftime("%Y-%m-%d-%H-%I-%S"),
          businessanalytics: c.businessanalytics_combined,
          structure: c.structure_combined,
          interpersonal: c.interpersonal_combined,
          totalscore: c.totalscore } }
    else
      # DUMMY DATA
      cases_analysis_chart_progress_data = []
      starting_date = Time.now - 1.month

      4.times do |n|
        cases_analysis_chart_progress_data << { id: n,
                                                date: starting_date.strftime("%Y-%m-%d"),
                                                businessanalytics: 2,
                                                structure: 2,
                                                interpersonal: 2,
                                                totalscore: 6 }
        starting_date = starting_date + 1.week
      end
    end
    cases_analysis_chart_progress_data
  end








  # STATISTICS

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


end