require 'spec_helper'

describe "Case Pages" do

	subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

  	before do
      1.times { FactoryGirl.create(:user,id: 2) }

      11.times {  user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                  "Some Subject", source: "Some Source",
                  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                  structure_comment: "Structure Comment",
                  analytical_comment: "Analytical Comment",
                  commercial_comment: "Commercial Comment",
                  conclusion_comment: "Conclusion Comment",
                  comment: "Overall Comment",
                  notes: "Some Notes") }

      sign_in user
      visit cases_path

    end

    it { should have_selector('title', text: 'Your Cases') }


    describe "pagination" do

      it { should have_selector('div.application_pagination') }

      it "should list each case" do
        
        user.cases.paginate(per_page: 10, page: 1).each do |c|
          page.should have_selector('strong', text: c.interviewer.name)
        end

      end
    end

  end



  describe "#show" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

    before do

      1.times { FactoryGirl.create(:user,id: 2) } # so that interviewer id works

      1.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                  "Some Subject", source: "Some Source",
                  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                  structure_comment: "Structure Comment",
                  analytical_comment: "Analytical Comment",
                  commercial_comment: "Commercial Comment",
                  conclusion_comment: "Conclusion Comment",
                  comment: "Overall Comment",
                  notes: "Some Notes") }

      sign_in user
      visit case_path(1)
      # save_and_open_page
    end

    it "should contain the right scores" do
      page.should have_selector('div', text: '5')
      page.should have_selector('div', text: '9')
      page.should have_selector('div', text: '10')
      page.should have_selector('div', text: '1')
    end

  end




  describe "#new case" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

    before do
      1.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
            "Some Subject", source: "Some Source",
            structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
            structure_comment: "Structure Comment",
            analytical_comment: "Analytical Comment",
            commercial_comment: "Commercial Comment",
            conclusion_comment: "Conclusion Comment",
            comment: "Overall Comment",
            notes: "Some Notes") }
      sign_in user
      visit '/cases/new?user_id=1'
      save_and_open_page
    end

    it "should load the page without errors" do
      page.should have_selector('title', text: 'Give Feedback')
    end
  end


  describe "create case" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

    before do
      1.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
            "Some Subject", source: "Some Source",
            structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
            structure_comment: "Structure Comment",
            analytical_comment: "Analytical Comment",
            commercial_comment: "Commercial Comment",
            conclusion_comment: "Conclusion Comment",
            comment: "Overall Comment",
            notes: "Some Notes") }
      sign_in user
      visit '/cases/new?user_id=1'
      #save_and_open_page 
    end

    let(:submit) { "Send case feedback" }

    describe "with invalid information" do

      it "should not create a case" do
        expect { click_button submit }.not_to change(Case, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Give Feedback') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before do

        #save_and_open_page 

        find(:xpath, "//input[@id='case_user_id']").set user.id
        find(:xpath, "//input[@id='case_interviewer_id']").set "2"

        fill_in "cases_new_datepicker", with: "12/12/2010"
        fill_in "case_subject", with: "Some Subject"
        fill_in "case_source", with: "Some Source"
        fill_in "case_structure", with: 5
        fill_in "case_analytical", with: 9
        fill_in "case_commercial", with: 10
        fill_in "case_conclusion", with: 1
        fill_in "case_structure_comment", with: "Structure Comment"
        fill_in "case_analytical_comment", with: "Analytical Comment"
        fill_in "case_commercial_comment", with: "Commercial Comment"
        fill_in "case_conclusion_comment", with: "Conclusion Comment"
        fill_in "case_comment", with: "Overall Comment"

      end
      
      it "should create a case" do
        expect { click_button submit }.to change(Case, :count).by(1)
      end

      describe "after saving a case, redirect and flash" do

         before { click_button submit }

         it { should have_selector('title', text: "Map") }
         it { should have_selector('div.alert.alert-success', text: 'Feedback Sent') }
         it { should have_link('Sign out') }

      end

    end

  end

  describe "#analysis" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

    before do
      1.times { FactoryGirl.create(:user,id: 2) } # so that interviewer id works

      2.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                "Some Subject", source: "Some Source",
                structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                structure_comment: "Structure Comment",
                analytical_comment: "Analytical Comment",
                commercial_comment: "Commercial Comment",
                conclusion_comment: "Conclusion Comment",
                comment: "Overall Comment",
                notes: "Some Notes") }

      sign_in user
      visit '/cases/analysis'
      #save_and_open_page
    end

    it { should have_selector('title', text: 'Your Progress') }

    # NEED JAVASCRIPT TESTS HERE!

    it "should list each user" do
      user.cases.each do |c|
        page.should have_selector('div', text: c.structure_comment)
        page.should have_selector('div', text: c.analytical_comment)
        page.should have_selector('div', text: c.commercial_comment)
        page.should have_selector('div', text: c.conclusion_comment)
      end
    end

  end

end