require 'spec_helper'

describe Case do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @case = user.cases.build(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
    				"Some Subject", source: "Some Source",
  				  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
				    structure_comment: "Structure Comment",
				    analytical_comment: "Analytical Comment",
				    commercial_comment: "Commercial Comment",
				    conclusion_comment: "Conclusion Comment",
				    comment: "Overall Comment",
				    notes: "Some Notes")
  end

  subject { @case }

  it { should respond_to(:user_id) }
  it { should respond_to(:interviewer_id) }
  it { should respond_to(:date) }
  it { should respond_to(:subject) }
  it { should respond_to(:source) }
  it { should respond_to(:structure) }
  it { should respond_to(:analytical) }
  it { should respond_to(:commercial) }
  it { should respond_to(:conclusion) }

  it { should respond_to(:structure_comment) }
  it { should respond_to(:analytical_comment) }
  it { should respond_to(:commercial_comment) }
  it { should respond_to(:conclusion_comment) }

  it { should respond_to(:comment) }
  it { should respond_to(:notes) }

  # ?
  it { should respond_to(:user) }

  # ?
  its(:user) { should == user }

  it { should be_valid }

  # Not possible to protect user_id with form & user_id system?
  # describe "accessible attributes" do
  #   it "should not allow access to user_id" do
  #     expect do
  #       Case.new(user_id: "1")
  #     end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  describe "when user_id is not present" do
    before { @case.user_id = nil }
    it { should_not be_valid }
  end

  describe "when marker_id is not present" do
    before { @case.interviewer_id = nil }
    it { should_not be_valid }
  end

  describe "with blank date" do
    before { @case.date = " " }
    it { should_not be_valid }
  end

  describe "with blank subject" do
    before { @case.subject = " " }
    it { should_not be_valid }
  end

  describe "with subject that is too long" do
    before { @case.subject = "a" * 501 }
    it { should_not be_valid }
  end


  describe "with source that is too long" do
    before { @case.source = "a" * 101 }
    it { should_not be_valid }
  end



  describe "with blank structure score" do
    before { @case.structure = "" }
    it { should_not be_valid }
  end

  describe "with structure score < 1" do
    before { @case.structure = 0 }
    it { should_not be_valid }
  end

  describe "with structure score > 10" do
    before { @case.structure = 11 }
    it { should_not be_valid }
  end


  describe "with blank analytical score" do
    before { @case.analytical = "" }
    it { should_not be_valid }
  end

  describe "with analytical score < 1" do
    before { @case.analytical = 0 }
    it { should_not be_valid }
  end

  describe "with analytical score > 10" do
    before { @case.analytical = 11 }
    it { should_not be_valid }
  end


  describe "with blank commercial score" do
    before { @case.commercial = "" }
    it { should_not be_valid }
  end

  describe "with commercial score < 1" do
    before { @case.commercial = 0 }
    it { should_not be_valid }
  end

  describe "with commercial score > 10" do
    before { @case.commercial = 11 }
    it { should_not be_valid }
  end



  describe "with blank conclusion score" do
    before { @case.conclusion = "" }
    it { should_not be_valid }
  end

  describe "with conclusion score < 1" do
    before { @case.conclusion = 0 }
    it { should_not be_valid }
  end

  describe "with conclusion score > 10" do
    before { @case.conclusion = 11 }
    it { should_not be_valid }
  end


  describe "with structure comment that is too long" do
    before { @case.structure_comment = "a" * 501 }
    it { should_not be_valid }
  end

  describe "with analytical comment that is too long" do
    before { @case.analytical_comment = "a" * 501 }
    it { should_not be_valid }
  end

  describe "with commercial comment that is too long" do
    before { @case.commercial_comment = "a" * 501 }
    it { should_not be_valid }
  end

  describe "with conclusion comment that is too long" do
    before { @case.conclusion_comment = "a" * 501 }
    it { should_not be_valid }
  end


  describe "with overall comment that is too long" do
    before { @case.comment = "a" * 501 }
    it { should_not be_valid }
  end

  describe "with notes that are too long" do
    before { @case.notes = "a" * 1001 }
    it { should_not be_valid }
  end



  describe "interviewer should be user found by interviewer_id" do

    let(:user) { FactoryGirl.create(:user, id: 2) }

    before { @case.save }

    its(:interviewer) { should == user }

  end


  describe "score should equal sum of four sub-scores" do

    before { @case.save }

    its(:score) { should == 25 }

  end

  describe "chart_show_radar should be correctly assembled and contain case scores" do

    before { @case.save }

    its(:chart_show_radar) { should include("[{criteria: \"Structure\", score: 5},") }
    its(:chart_show_radar) { should include("{criteria: \"Commercial\", score: 10},") }
    its(:chart_show_radar) { should include("{criteria: \"Conclusion\", score: 1},") }
    its(:chart_show_radar) { should include("{criteria: \"Analytical\", score: 9}]") }

  end

  describe "chart_analysis_radar" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      11.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                  "Some Subject", source: "Some Source",
                  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                  structure_comment: "Structure Comment",
                  analytical_comment: "Analytical Comment",
                  commercial_comment: "Commercial Comment",
                  conclusion_comment: "Conclusion Comment",
                  comment: "Overall Comment",
                  notes: "Some Notes") }
    end

    # Does not test first5 and last 5 cases well, 
    # pending getting factory girl to make different kinds of cases!
    it "should be in a valid format, with the correct scores" do
      Case.chart_analysis_radar(user).should include("first5: 5.0") # Structure
      Case.chart_analysis_radar(user).should include("last5: 5.0")
      Case.chart_analysis_radar(user).should include("first5: 10.0") # Commercial
      Case.chart_analysis_radar(user).should include("last5: 10.0")
      Case.chart_analysis_radar(user).should include("first5: 1.0") # Conclusion 
      Case.chart_analysis_radar(user).should include("last5: 1.0")
      Case.chart_analysis_radar(user).should include("first5: 9.0") # Analytical   
      Case.chart_analysis_radar(user).should include("last5: 9.0")
    end
  
  end



  describe "chart_analysis_progress" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      11.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                  "Some Subject", source: "Some Source",
                  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                  structure_comment: "Structure Comment",
                  analytical_comment: "Analytical Comment",
                  commercial_comment: "Commercial Comment",
                  conclusion_comment: "Conclusion Comment",
                  comment: "Overall Comment",
                  notes: "Some Notes") }
    end
    
    # No test for syntax of JSON, or that JSON is being made in controller

    it "should contain the correct number of data points" do
      Case.chart_analysis_progress(user).should have(11).items
    end
  
  end


end
