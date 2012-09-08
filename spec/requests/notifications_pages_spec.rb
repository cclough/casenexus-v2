require 'spec_helper'

describe "Notification Pages" do


	subject { page }

  describe "#index" do

    let(:user) { FactoryGirl.create(:user) }

  	before do
      1.times { FactoryGirl.create(:user,id: 2) }

      11.times { user.notifications.create(sender_id: 2, 
                 ntype: "feedback_new", content: "Some subject",
                 url: "http://ww.asd.com/" , event_date: Date.new(2012, 3, 3)) }

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
                ntype: "feedback_new", content: "Some subject",
                url: "http://ww.asd.com/" , event_date: Date.new(2012, 3, 3)) }

      sign_in user
      visit notification_path(1)
      # save_and_open_page
    end

    it "should contain the right info" do
      page.should have_content('Some subject')
      page.should have_content('feedback_new')
      page.should have_content('http://ww.asd.com/')
    end

    it "should set read to true" do
    	Notification.find(1).read.should == true
    end

    it "should leave read as true when you visit again" do
    	visit notification_path(1)
    	Notification.find(1).read.should == true
    end
  end





  # describe "signup" do
    
  #   before { visit signup_path }

  #   let(:submit) { "Create my account" }

  #   describe "with invalid information" do
  #     it "should not create a user" do
  #       expect { click_button submit }.not_to change(User, :count)
  #     end

  #     describe "after submission" do
  #       before { click_button submit }

  #       it { should have_selector('title', text: 'Sign up') }
  #       it { should have_content('error') }
  #       it { should_not have_content('Password digest') }
  #     end
  #   end

  #   describe "with valid information" do

  #     before do
  #       fill_in "First name", with: "Example"
  #       fill_in "Last name", with: "User"
  #       fill_in "Email", with: "user@example.com"
  #       fill_in "Password", with: "foobar"
  #       fill_in "Confirm Password", with: "foobar"
  #       # capybara can't fill_in hidden fields - using a javascript workaround! cool!
  #       find(:xpath, "//input[@id='lat']").set "51"
  #       find(:xpath, "//input[@id='lng']").set "1"
  #       fill_in "Describe your current situation", with: "a" * 51
  #       check "Accept the terms and conditions"
  #     end
      
  #     it "should create a user" do
  #       expect { click_button submit }.to change(User, :count).by(1)
  #     end

  #     describe "should receive a welcome email" do

  #       subject { last_email_sent }

  #       it { should be_delivered_from("info@casenexus.com") }
  #       it { should deliver_to("Example User <user@example.com>") }
  #       it { should have_subject("casenexus: Welcome") }
  #       it { should have_body_text("Welcome") }
  #       it { should have_body_text("http://www.casenexus.com/signin") }

  #     end

  #     describe "after saving a user" do
  #       before { click_button submit }

  #       let(:user) { User.find_by_email("user@example.com") }

  #       it { should have_selector('title', text: "Map") }
  #       it { should have_selector('div.alert.alert-success', text: 'Welcome') }
  #       it { should have_link('Sign out') }
  #     end

  #   end

  # end







end