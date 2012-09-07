require 'spec_helper'

describe "User pages" do

  subject { page }


  ### Map Page
  describe "index" do

    # Lat & Lng assigned so that test on Local Filter below works (not relevant to any other test)
    let(:user) { FactoryGirl.create(:approved, first_name: "Steve",
                 lat: 51.9011282326659, lng: -0.542411887645721) }

    # This is very slow!
    # but before(:all) doesn't seem to work with my tests below within 'describe' blocks
    before(:each) do
      30.times { FactoryGirl.create(:approved) }
      sign_in user
      visit users_path
    end

    after(:each) do
      User.delete_all
    end

    it { should have_selector('title', text: 'Map') }

    it { should have_selector('div', id: 'users_index_map') }
    it { should have_selector('div', id: 'users_index_panel_posts') }
    it { should have_selector('div', id: 'users_index_panel_user') }

    describe "pagination (& Global list selection)", js: true do

      before do
        click_link('users_index_users_button_filter')
        choose('users_listtype_global')
        sleep(3)
      end

      it { should have_selector('div.nexus_pagination') }

      it "should list each user" do
        User.approved.paginate(per_page: 7, page: 1).order('created_at desc').each do |user|
          page.should have_selector('strong', text: user.name)
        end
      end
    end

    describe "search works", js: true do
      before do
        fill_in "users_index_users_form_searchfield", with: "Steve"
      end

      it { should have_selector('strong', text: "Steve") }
    end


    describe "avatar displays", js: true do
      it { should have_selector('img', src: "/assets/avatars/user_yellow.png") }  
    end


    describe "filters", js: true do

      before(:all) { FactoryGirl.create(:approved, first_name: "Dave",
                     lat: 51.90155190493969, lng: -0.56060799360273) }
      before(:all) { FactoryGirl.create(:approved, first_name: "Bob",
                     lat: 46.7526281332615, lng: 7.96478263139727) }

      before do
        click_link('users_index_users_button_filter')
      end

      it 'using list_global gives all approved results' do
        choose('users_listtype_local')

        page.should have_content('Dave')
        page.should_not have_content('Bob')
      end

      # Not doing a test for global currently as can't figure one out
      # - prob not really neccessary either as already done in 'paginate' test above
    end


  	###### THE ELUSIVE MAP TEST ######

    # Trigger Click - test for entire map system

    #  Current problem - show panel doesn't popup - google map not loading properly

    describe "triggering a marker click should correctly show the user profile (test of entire map system)", :js => true do
      before do
        sleep(4)
        click_link('users_index_users_item_' + user.id)
        sleep(4)
      end
      it { should have_content('Person') }      
    end

end

  describe "#show" do

    let(:user) { FactoryGirl.create(:approved, first_name: "Steve") }

    before do
      sign_in user
      visit user_path(user)
    end

    it "should show the user's profile" do
      page.should have_content(user.first_name)
    end

    describe "send feedback button should lead to new case form" do
      
      before do
        click_link('users_index_user_button_sendfeedback')
      end

      it { should have_selector('title', text: 'Give Feedback') }

    end

    describe "should not show the profile if user is not approved" do

      before do
        FactoryGirl.create(:user)
        visit user_path(2)
        save_and_open_page
      end

      it { should have_selector('title', text: 'Map') }

    end

    # more buttons etc. to come here

  end

  ### Signup/Registration
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('title', text: full_title('Sign up')) }

    ###### NEED GOOGLE MAP TEST HERE ########
  end

  describe "signup" do
    
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content('Password digest') }
      end
    end

    describe "with valid information" do

      before do
        fill_in "First name", with: "Example"
        fill_in "Last name", with: "User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
        # capybara can't fill_in hidden fields - using a javascript workaround! cool!
        find(:xpath, "//input[@id='lat']").set "51"
        find(:xpath, "//input[@id='lng']").set "1"
        fill_in "Describe your current situation", with: "a" * 51
        check "Accept the terms and conditions"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "should receive a welcome email" do

        subject { last_email_sent }

        it { should be_delivered_from("info@casenexus.com") }
        it { should deliver_to("Example User <user@example.com>") }
        it { should have_subject("casenexus: Welcome") }
        it { should have_body_text("Welcome") }
        it { should have_body_text("http://www.casenexus.com/signin") }

      end

      describe "after saving a user" do
        before { click_button submit }

        let(:user) { User.find_by_email("user@example.com") }

        it { should have_selector('title', text: "Map") }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end

    end

  end


  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      # Put more tests here
      it { should have_selector('title', text: "Edit Profile") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_first_name) { "New" }
      let(:new_last_name) { "Name" }
      let(:new_email) { "new@example.com" }
      let(:new_lat) { 52 }
      let(:new_lng) { 3 }
      let(:new_status) { "z" * 51 }

      let(:new_skype) { "christianclough" }
      let(:new_linkedin) { "christian.clough" }

      let(:new_education1) { "Imperial" }
      let(:new_education2) { "Oxford" }
      let(:new_education3) { "Cambridge" }
      let(:new_experience1) { "MRC-T" }
      let(:new_experience2) { "WHO" }
      let(:new_experience3) { "Candesic" }

      # DATES ARE A NIGHTMARE
      # let(:new_education1_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_education1_to) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_education2_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_education2_to) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_education3_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_education3_to) { randomDate(:year_range => 3, :year_latest => 0) }

      # let(:new_experience1_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_experience1_to) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_experience2_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_experience2_to) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_experience3_from) { randomDate(:year_range => 3, :year_latest => 0) }
      # let(:new_experience3_to) { randomDate(:year_range => 3, :year_latest => 0) }


      before do
        fill_in "First name",       with: new_first_name
        fill_in "Last name",        with: new_last_name
        fill_in "Email",            with: new_email
        find(:xpath, "//input[@id='lat']").set new_lat
        find(:xpath, "//input[@id='lng']").set new_lng
        fill_in "Describe your current situation", with: new_status

        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password

        fill_in "Skype", with: new_skype
        fill_in "Linkedin", with: new_linkedin

        fill_in "user_education1", with: new_education1
        fill_in "user_education2", with: new_education2
        fill_in "user_education3", with: new_education3
        fill_in "user_experience1", with: new_experience1
        fill_in "user_experience2", with: new_experience2
        fill_in "user_experience3", with: new_experience3

        # DATES ARE A NIGHTMARE
        # fill_in "user_education1_from", with: new_education1_from
        # fill_in "user_education1_to", with: new_education1_to
        # fill_in "user_education2_from", with: new_education2_from
        # fill_in "user_education2_to", with: new_education2_to
        # fill_in "user_education3_from", with: new_education3_from
        # fill_in "user_education3_to", with: new_education3_to

        # fill_in "user_experience1_from", with: new_experience1_from
        # fill_in "user_experience1_to", with: new_experience1_to
        # fill_in "user_experience2_from", with: new_experience2_from
        # fill_in "user_experience2_to", with: new_experience2_to
        # fill_in "user_experience3_from", with: new_experience3_from
        # fill_in "user_experience3_to", with: new_experience3_to

        click_button "Save changes"
      end

      it { should have_selector('title', text: "Map") }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_selector('div.alert.alert-success') }

      specify { user.reload.first_name.should == new_first_name }
      specify { user.reload.last_name.should == new_last_name }
      specify { user.reload.email.should == new_email }
    
      specify { user.reload.lat.should == new_lat }
      specify { user.reload.lng.should == new_lng }
      specify { user.reload.status.should == new_status }

      specify { user.reload.password.should == user.password }

      specify { user.reload.skype.should == new_skype }
      specify { user.reload.linkedin.should == new_linkedin }

      specify { user.reload.education1.should == new_education1 }
      specify { user.reload.education2.should == new_education2 }
      specify { user.reload.education3.should == new_education3 }
      specify { user.reload.experience1.should == new_experience1 }
      specify { user.reload.experience2.should == new_experience2 }
      specify { user.reload.experience3.should == new_experience3 }

      # DATES ARE A NIGHTMARE
      # specify { user.reload.education1_from.should == new_education1_from }
      # specify { user.reload.education1_to.should == new_education1_to }
      # specify { user.reload.education2_from.should == new_education2_from }
      # specify { user.reload.education2_to.should == new_education2_to }
      # specify { user.reload.education3_from.should == new_education3_from }
      # specify { user.reload.education3_to.should == new_education3_to }

      # specify { user.reload.experience1_from.should == new_experience1_from }
      # specify { user.reload.experience1_to.should == new_experience1_to }
      # specify { user.reload.experience2_from.should == new_experience2_from }
      # specify { user.reload.experience2_to.should == new_experience2_to }
      # specify { user.reload.experience3_from.should == new_experience3_from }
      # specify { user.reload.experience3_to.should == new_experience3_to }

    end
  end

end

# def randomDate(params={})
#   years_back = params[:year_range] || 5
#   latest_year  = params [:year_latest] || 0
#   year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
#   month = (rand * 12).ceil
#   day = (rand * 31).ceil
#   series = [date = Time.local(year, month, day)]
#   if params[:series]
#     params[:series].each do |some_time_after|
#       series << series.last + (rand * some_time_after).ceil
#     end
#     return series
#   end
#   date
# end
