require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('title', text: 'Sign in') }
    it { should have_selector('input', value: 'Sign in') }
  end


  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_error_message }

      describe "after visiting another page" do
        before { click_link "About" }
        it { should_not have_error_message }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: 'Map') }
      it { should have_selector('img', id: "logo-globe") }
      it { should have_selector('img', id: "logo-text") }
      it { should have_selector('i', class: "icon-user") }

      it { should_not have_selector('title', text: 'Sign in') }

      describe "followed by signout" do
        before { click_link "signout" }
				it { should have_selector('img', src: 'misc/banner.png') }
      end
    end
  end


  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit Profile')
          end

          describe "when signing in again" do
            before do
              click_link "signout"
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"              
            end

            it "should render the default (profile) page" do
              page.should have_selector('h1', text: 'Map')
            end
          end
        end
      end
      
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
          it { should have_selector('div.alert.alert-notice') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

      end
    end

	 	##### CHECK HERE ALL SUBISSIONS TO ALL DIFFERENT CONTROLLER RESTFUL ACTIONS

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      # This test below is weak
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit Profile') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    # ADMIN USER TESTS NOT REQUIRED AS NO SPECIFC ACTIONS YET
    # describe "as non-admin user" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   let(:non_admin) { FactoryGirl.create(:user) }

    #   before { sign_in non_admin }

    #   describe "submitting a DELETE request to the Users#destroy action" do
    #     before { delete user_path(user) }
    #     specify { response.should redirect_to(root_path) }
    #   end
    # end

  end




end