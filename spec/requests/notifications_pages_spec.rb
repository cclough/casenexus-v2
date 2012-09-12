require 'spec_helper'

describe "Notification Pages" do


	subject { page }

  describe "#index" do

    let(:user) { FactoryGirl.create(:user) }

  	before do
      1.times { FactoryGirl.create(:user, id: 2) }

      11.times { user.notifications.create(sender_id: 2, 
                 ntype: "feedback", content: "Some subject",
                 event_date: Date.new(2012, 3, 3)) }

      sign_in user
      visit notifications_path

    end

    it { should have_selector('title', text: 'Your Notifications') }

    describe "pagination" do

      it { should have_selector('div', class: 'nexus_pagination') }

      it "should list each notification" do
        
        user.notifications.paginate(per_page: 10, page: 1).each do |notification|
          page.should have_selector('strong', text: notification.sender.name)
        end

      end
    end

  end


  describe "#show" do

    let(:user) { FactoryGirl.create(:user) }

    before do

      1.times { FactoryGirl.create(:user, id: 2) } # so that interviewer id works

      1.times { user.notifications.create(sender_id: 2, 
                 ntype: "feedback", content: "Some subject",
                 event_date: Date.new(2012, 3, 3)) }

      sign_in user
      visit notification_path(1)
      # save_and_open_page
    end

    it "should contain the right info" do
      page.should have_content('Some subject')
      page.should have_content('feedback')
    end

    it "should set read to true" do
    	Notification.find(1).read.should == true
    end

    it "should leave read as true when you visit again" do
    	visit notification_path(1)
    	Notification.find(1).read.should == true
    end
  end



  describe "send message", js: true do
    
    let(:user) { FactoryGirl.create(:approved) }

    before do
      sign_in user
      sleep(0.2)
      click_link('users_index_users_button_filter')
      choose('users_listtype_global')
      sleep(0.2)
      page.execute_script "$('#users_index_users_item_1').trigger('click');"
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
      end
      
      it "should create a notification" do
        expect { click_button submit }.to change(Notification, :count).by(1)
      end

      describe "should receive a welcome email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to("Person 3 <person_3@example.com>") }
        it { should have_subject("casenexus: You have been sent a message") }
        it { should have_body_text("You have been sent a message by Person 3") }
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
    
    let(:user) { FactoryGirl.create(:approved) }

    before do
      sign_in user
      sleep(0.2)
      click_link('users_index_users_button_filter')
      choose('users_listtype_global')
      sleep(0.2)
      page.execute_script "$('#users_index_users_item_1').trigger('click');"
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

      describe "should receive a welcome email" do

        subject { last_email_sent }

        it { should be_delivered_from("mailer@casenexus.com") }
        it { should deliver_to("Person 5 <person_5@example.com>") }
        it { should have_subject("casenexus: You have been sent a feedback request") }
        it { should have_body_text("You have been sent a feedback request by Person 5") }
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




end