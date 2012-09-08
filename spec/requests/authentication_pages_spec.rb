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
              page.should have_selector('div', id: 'users_index_map')
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

        describe "visiting the user show action" do
          before { visit user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

      end

      describe "in the Cases controller" do

        describe "visiting the case index" do
          before { visit cases_path }
          it { should have_selector('title', text: 'Sign in') }
        end


        describe "visiting the case show action" do
          
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

            visit case_path(1)
          end

          it { should have_selector('title', text: 'Sign in') }
        end


        describe "visiting the new case action" do
          before { visit new_case_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the create action" do
          before { post cases_path }
          specify { response.should redirect_to(signin_path)}
        end

      end

      describe "in the Notifications controller" do

        describe "visiting the notification index" do
          before { visit notifications_path }
          it { should have_selector('title', text: 'Sign in') }
        end


        describe "visiting the notification show action" do
          
          before do

            1.times { user.notifications.build(sender_id: 2, 
                      ntype: "feedback_new", content: "Some subject",
                      url: "http://ww.asd.com/" , event_date: Date.new(2012, 3, 3)) }
            
            visit notification_path(1)

          end

          it { should have_selector('title', text: 'Sign up') }
        end


        describe "submitting to the create action" do
          before { post notifications_path }
          specify { response.should redirect_to(signin_path)}
        end

      end

    end



    ##### CHECK CORRECT USER FOR ALL CONTROLLERS

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }


      ##### USERS CONTROLLER

      # This test below is weak
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit Profile') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end


      ##### CASES CONTROLLER   

      describe "visiting the case show action" do

        let(:user2) { FactoryGirl.create(:user) }
        
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

          sign_in user2
          visit case_path(1)
        end

        it { should have_selector('title', text: 'Map') }

      end


      # Not possible or neccessary for Cases Index page?

      ##### NOTIFICATIONS CONTROLLER


      describe "visiting the notification show action" do

        let(:user2) { FactoryGirl.create(:user) }
        
        before do
          1.times { user.notifications.build(sender_id: 2, 
                    ntype: "feedback_new", content: "Some subject",
                    url: "http://ww.asd.com/" , event_date: Date.new(2012, 3, 3)) }

          sign_in user2
          visit notification_path(1)
        end

        it { should have_selector('title', text: 'Map') }
        
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