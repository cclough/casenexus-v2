require 'spec_helper'

describe "User pages" do

  subject { page }

  ### Map Page
  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }
 
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'Map') }

    it { should have_selector('div', id: 'users_index_map') }
    it { should have_selector('div', id: 'users_index_panel_posts') }
    it { should have_selector('div', id: 'users_index_panel_user') }
  
  	###### NEED MORE JAVASCRIPT TESTING OF MAP FUNCTION ETC HERE!!######
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
        fill_in "First_Name",   with: "Example"
        fill_in "Last_Name",    with: "User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"        
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving a user" do
        before { click_button submit }

        let(:user) { User.find_by_email("user@example.com") }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end


end