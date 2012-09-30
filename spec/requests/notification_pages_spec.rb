require 'spec_helper'

describe "Notification Pages" do


	subject { page }

  describe "#index" do

    let(:user) { FactoryGirl.create(:user, completed: true) }
    let(:user2) { FactoryGirl.create(:user) }
  	before do
      11.times { user.notifications.create(sender_id: user2.id, 
                 ntype: "feedback", content: "Some subject",
                 event_date: Date.new(2012, 3, 3)) }

      sign_in user
      visit notifications_path

    end

    it { should have_selector('title', text: 'Your Notifications') }

    describe "pagination" do

      it { should have_selector('div', class: 'application_pagination') }

      it "should list each notification" do
        
        user.notifications.paginate(per_page: 10, page: 1).each do |notification|
          page.should have_selector('strong', text: notification.sender.name)
        end

      end
    end

  end







  describe "#show" do

    let(:user) { FactoryGirl.create(:user, completed: true) }

    let(:notification) { user.notifications.create(sender_id: 3, 
                         ntype: "feedback", content: "Some subject",
                         event_date: Date.new(2012, 3, 3)) }

    before do

      1.times { FactoryGirl.create(:user, id: 3) } # so that interviewer id works
      sign_in user
      visit notification_path(notification)
      # save_and_open_page
    end

    it "should contain the right info" do
      page.should have_content('Some subject')
      page.should have_content('feedback')
    end

    it "should set read to true" do
    	Notification.find(notification).read.should == true
    end

    it "should leave read as true when you visit again" do
    	visit notification_path(notification)
    	Notification.find(notification).read.should == true
    end
  end









  describe "send message", js: true do
    
    let(:user) { FactoryGirl.create(:approved, completed: true) }
    let(:user2) { FactoryGirl.create(:approved, completed: true) }

    before do

      # Create friendship
      user.invite user2
      user2.approve user

      sign_in user
      sleep(0.2)
      page.execute_script "$('#users_index_users_form_button_1').trigger('click');"
      sleep(0.2)
      page.execute_script "$('#users_index_users_item_2').trigger('click');"
      sleep(0.2)
      page.execute_script "$('#users_index_user_button_message').trigger('click');"
      sleep(0.2)
    end

    let(:submit) { "Send Message" }

    describe "without content" do
      it "should not create a notification" do
        expect { click_button submit }.not_to change(Notification, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before do
        fill_in 'notification_content', with: "Testing 123"
        sleep(0.5)
      end
      
      it "should create a notification" do
        expect { click_button submit }.to change(Notification, :count).by(1)
      end

      describe "should send a message email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to(user.name + " <" + user.email + ">") }
        it { should have_subject("casenexus: You have been sent a message") }
        it { should have_body_text("You have been sent a message by " + user.name) }
        it { should have_body_text("notifications/1") }

      end

      describe "after saving a notification" do
        before do
          click_button submit
          sleep(1)
        end

        it { should have_selector('div.alert.alert-success') }

      end

    end

  end









  describe "send feedback request", js: true do
    
    let(:user) { FactoryGirl.create(:approved, completed: true) }
    let(:user2) { FactoryGirl.create(:approved, completed: true) }

    before do
      # Create friendship
      user.invite user2
      user2.approve user

      sign_in user
      sleep(0.2)
      page.execute_script "$('#users_index_users_form_button_1').trigger('click');"
      sleep(0.2)
      page.execute_script "$('#users_index_users_item_2').trigger('click');"
      sleep(0.2)
      page.execute_script "$('#users_index_user_button_feedback_req').trigger('click');"
      sleep(0.2)
    end

    let(:submit) { "Send Feedback Request" }

    describe "without subject" do
      it "should not create a notification" do
        fill_in 'modal_feedback_req_datepicker', with: '12/12/2012'
        expect { click_button submit }.not_to change(Notification, :count)
      end

      describe "after submission" do
        before do
          fill_in 'modal_feedback_req_datepicker', with: '12/12/2012'
          click_button submit
        end

        it { should have_content('error') }
      end
    end

    describe "without date" do
      it "should not create a notification" do
        fill_in 'notification_content', with: 'xxxx'
        expect { click_button submit }.not_to change(Notification, :count)
      end

      describe "after submission" do
        before do
          fill_in 'notification_content', with: 'xxxx'
          click_button submit
        end

        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before do
        fill_in 'modal_feedback_req_datepicker', with: '12/12/2012'
        fill_in 'notification_content', with: "Testing 123"
      end
      
      it "should create a notification" do
        expect { click_button submit }.to change(Notification, :count).by(1)
      end




      describe "should receive a feedback request email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to(user.name + " <" + user.email + ">") }
        it { should have_subject("casenexus: You have been sent a feedback request") }
        it { should have_body_text("You have been sent a feedback request by " + user.name) }
        it { should have_body_text("12/12/2012") }
        it { should have_body_text("cases/new") }

      end

      describe "after saving a notification" do
        before do
          click_button submit
          sleep(1)
        end

        it { should have_selector('div.alert.alert-success') }

      end

    end

  end










  describe "create case" do

    let(:user) { FactoryGirl.create(:user, completed: true) }
    let(:user2) { FactoryGirl.create(:user) }

    before do

      # Create friendship
      user.invite user2
      user2.approve user

      1.times { user.cases.create(interviewer_id: user2.id, date: Date.new(2012, 3, 3), subject:
            "Some Subject", source: "Some Source",
            structure: 5,analytical: 9,commercial: 10,conclusion: 1, 
            structure_comment: "Structure Comment",
            analytical_comment: "Analytical Comment",
            commercial_comment: "Commercial Comment",
            conclusion_comment: "Conclusion Comment",
            comment: "Overall Comment",
            notes: "Some Notes") }

      sign_in user
      visit '/cases/new?user_id=' + user.id.to_s
      #save_and_open_page 
    end

    let(:submit) { "Send case feedback" }

    describe "with invalid information" do

      it "should not create a case" do
        expect { click_button submit }.not_to change(Notification, :count)
      end

    end

    describe "with valid information" do

      before do

        #save_and_open_page 

        find(:xpath, "//input[@id='case_user_id']").set user.id
        find(:xpath, "//input[@id='case_interviewer_id']").set user2.id

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
      
      it "should create a notification" do
        expect { click_button submit }.to change(Notification, :count).by(1)
      end

      describe "should receive a feedback new email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to(user2.name + " <" + user2.email + ">") }
        it { should have_subject("casenexus: You have been sent case feedback") }
        it { should have_body_text("You have been sent case feedback by " + user2.name) }
        it { should have_body_text("12/12/2010") }
        it { should have_body_text("cases/2") }

      end

    end

  end










  describe "signup user" do
    
    let(:user2) { FactoryGirl.create(:user, completed: true) }

    before do
      visit root_path
    end

    let(:submit) { "Sign up" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Notification, :count)
      end
    end

    describe "with valid information" do

      before do
        fill_in "user_first_name", with: "Example"
        fill_in "user_last_name", with: "User"
        fill_in "user_email", with: "user@example.com"
        fill_in "user_password", with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
        check "user_accepts_tandc"
      end

      it "should create a notification" do
        expect { click_button submit }.to change(Notification, :count).by(1)
      end

      describe "should receive a welcome email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to("Example User <user@example.com>") }
        it { should have_subject("casenexus: Welcome") }
        it { should have_body_text("user@example.com") }
        it { should have_body_text("http://localhost:3000/") }

      end

    end

  end


end