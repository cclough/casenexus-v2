require 'spec_helper'

describe "Header" do

  subject { page }

  describe "links lead to correct pages" do

	  let(:user) { FactoryGirl.create(:user, completed: true) }
	  
	  before do
	  	sign_in user
	  end
	  
	  describe "Map link" do
	  	before do
	  		click_link('Users')
	  	end

	  	it { should have_selector('title', text: "Map")}
	  end

	  describe "Cases link" do
	  	before do
	  		click_link('Case Index')
	  	end

	  	it { should have_selector('title', text: "Your Cases")}
	  end

	  describe "Edit Profile link" do
	  	before do
	  		click_link('Settings')
	  	end

	  	it { should have_selector('title', text: "Edit Profile")}
	  end

	  describe "Sign out link" do
	  	before do
	  		click_link('Sign out')
	  	end

			it { should have_selector('img', src: 'misc/banner.png') }
	  end

	  describe "Analysis link" do
	  	before do

	  		1.times { FactoryGirl.create(:user, id: 2) } # so that avatars work

		    1.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
		        "Some Subject", source: "Some Source",
		        structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
		        structure_comment: "Structure Comment",
		        analytical_comment: "Analytical Comment",
		        commercial_comment: "Commercial Comment",
		        conclusion_comment: "Conclusion Comment",
		        comment: "Overall Comment",
		        notes: "Some Notes") }

	  		click_link('Progress Analysis')
	  	end

	  	it { should have_selector('title', text: "Your Progress")}
	  end

	  describe "See all notifications link" do
	  	before do
	  		click_link('See all')
	  	end

	  	it { should have_selector('title', text: "Your Notifications")}
	  end

	end

	describe "has correct numbers for" do

	  let(:user) { FactoryGirl.create(:user, completed: true) }
	  let(:user2) { FactoryGirl.create(:user) }
	  before do
	  	sign_in user
	  end

	  describe "case count" do
	  	before do

	      # Create friendship
	      user.invite user2
	      user2.approve user

		    3.times { user.cases.create(interviewer_id: 2, date: Date.new(2012, 3, 3), subject:
                  "Some Subject", source: "Some Source",
                  structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
                  structure_comment: "Structure Comment",
                  analytical_comment: "Analytical Comment",
                  commercial_comment: "Commercial Comment",
                  conclusion_comment: "Conclusion Comment",
                  comment: "Overall Comment",
                  notes: "Some Notes") }
		    visit users_path
	  	end

	  	it { should have_selector('#header_menu_profile_casecount', text: '3') }

	  end


	  describe "unread notifications" do
	  	before do
	  		1.times { FactoryGirl.create(:user, id: 2) } # so that avatars work

	      7.times { user.notifications.create(sender_id: 2, 
	                ntype: "feedback_new", content: "Some subject",
	                event_date: Date.new(2012, 3, 3)) }

	      3.times { user.notifications.create(sender_id: 2, 
	                ntype: "feedback_new", content: "Some subject",
	                event_date: Date.new(2012, 3, 3),
	                read: true) }

		    visit users_path
	  	end

	  	it { should have_selector('#header_menu_notifications_unreadcount', text: '8') }

	  end


	end

	describe "show a notification" do

	  let(:user) { FactoryGirl.create(:user, completed: true) }

    before do
  		1.times { FactoryGirl.create(:user, id: 2) } # so that avatars work

      1.times { user.notifications.create(sender_id: 2, 
                ntype: "feedback_new", content: "Some subject",
                event_date: Date.new(2012, 3, 3)) }

       sign_in user

    end

    it "should list each notification" do
      #Notification.header.each do |notification|
        page.should have_selector('strong', text: user.notifications.first.sender.username)
      #end
    end

	end

end