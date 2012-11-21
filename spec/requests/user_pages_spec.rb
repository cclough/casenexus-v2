require 'spec_helper'

describe "User pages" do

  subject { page }

  ### Map Page
  describe "index" do

    # Lat & Lng assigned so that test on Local Filter below works (not relevant to any other test)
    let(:user) { FactoryGirl.create(:approved, first_name: "Steve",
                 lat: 51.9011282326659, lng: -0.542411887645721, completed: true) }

    # This is very slow!
    # but before(:all) doesn't seem to work with my tests below within 'describe' blocks
    before(:each) do
      30.times { FactoryGirl.create(:user) }
      sign_in user
    end

    after(:each) do
      User.delete_all
    end

    it { should have_selector('title', text: 'Map') }

    it { should have_selector('div', id: 'map_index_map') }
    it { should have_selector('div', id: 'map_index_panel_users') }
    it { should have_selector('div', id: 'map_index_panel_user') }

    describe "pagination (& Global list selection)", js: true do

      before do
        # Click global button
        page.execute_script "$('#map_index_users_form_button_1').trigger('click');"
        sleep(3)
      end

      it { should have_selector('div.application_pagination') }

      it "should list each user" do
        User.approved.paginate(per_page: 7, page: 1).order('created_at desc').each do |user|
          page.should have_selector('strong', text: user.name)
        end
      end
    end

    describe "search works", js: true do
      before do
        fill_in "map_index_users_form_searchfield", with: "Steve"

        page.execute_script "map_index_users_updatelist();"

      end

      it { should have_selector('strong', text: "Steve") }
    end


    describe "avatar displays", js: true do
      it { should have_selector('img', src: "/assets/avatars/avatar_orange.png") }  
    end


    describe "filters", js: true do

      before(:all) { FactoryGirl.create(:approved, first_name: "Dave",
                     lat: 51.90155190493969, lng: -0.56060799360273) }
      before(:all) { FactoryGirl.create(:approved, first_name: "Bob",
                     lat: 46.7526281332615, lng: 7.96478263139727) }

      before do
        page.execute_script "$('#map_index_users_form_button_0').trigger('click');"
      end

      it 'using list_global gives all results' do
        page.should have_content('Dave')
        page.should_not have_content('Bob')
      end

    end


  	###### THE AMAZING MAP TEST ######

    describe "triggering a marker click should correctly show the user profile (test of entire map system)", :js => true do
      before do
        sleep(0.2)
        page.execute_script "$('#map_index_users_form_button_1').trigger('click');"
        sleep(0.2)
        page.execute_script "$('#map_index_users_item_31').trigger('click');"
        sleep(0.2)
      end

      it { should have_content("cases") }      
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


    describe "should not show the message if user is not approved" do

      let(:user) { FactoryGirl.create(:user, completed: true) }

      before do
        visit user_path(user)
      end

      it { should_not have_content("a" * 51) }  

    end

  end



  ### Signup/Registration
  describe "signup page" do
    before { visit root_path }

    it { should have_selector('label', text: "Receive email notifications") }

  end

  describe "signup" do
    
    before { visit root_path }

    let(:submit) { "Sign up" }

    describe "with invalid information" do

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('label', text: "Receive email notifications") }
        it { should have_content('error') }
        it { should_not have_content('Password digest') }
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
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving a user" do
        before { click_button submit }

        it { should have_selector('title', text: "Sign up") }
      end

      describe "completing step 2" do

        before do

          click_button submit

          find(:xpath, "//input[@id='account_completeedit_lat']").set "51"
          find(:xpath, "//input[@id='account_completeedit_lng']").set "1"
          fill_in "account_complete_status", with: "a" * 51
          click_button submit

        end

        it { should have_selector('title', text: "Map") }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      
      end

    end

  end






  describe "edit" do
    let(:user) { FactoryGirl.create(:user, completed: true) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      # Put more tests here
      it { should have_selector('title', text: "Edit Profile") }
    end

    describe "with valid information" do
      let(:new_first_name) { "New" }
      let(:new_last_name) { "Name" }
      let(:new_email) { "new@example.com" }
      let(:new_lat) { 52 }
      let(:new_lng) { 3 }
      let(:new_status) { "z" * 51 }

      let(:new_skype) { "christianclough" }
      let(:new_linkedin) { "christian.clough@gmail.com" }

      before do
        fill_in "First name",       with: new_first_name
        fill_in "Last name",        with: new_last_name
        fill_in "Email",            with: new_email
        find(:xpath, "//input[@id='account_completeedit_lat']").set new_lat
        find(:xpath, "//input[@id='account_completeedit_lng']").set new_lng
        fill_in "user_edit_status", with: new_status

        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password

        fill_in "Skype", with: new_skype
        fill_in "Linkedin", with: new_linkedin

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

    end
  end

end
