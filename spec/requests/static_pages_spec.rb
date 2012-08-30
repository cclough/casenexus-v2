require 'spec_helper'

describe "Static Pages" do

	subject { page }

	describe "Home page" do

		before { visit root_path }

		it { should have_selector('img', src: 'misc/banner.png') }
		it { should have_selector('title',
					text: full_title('')) }
		it { should_not have_selector('title', text: '| Home') }
  
  	# NEED TO COMPLETE THIS - SIGN-IN DOESNT WORK
    # describe "for signed-in users" do

    #   let(:user) { FactoryGirl.create(:user) }

    #   before do
    #     sign_in user
    #     visit root_path
    #   end

    #   describe "should render the user's xxxx" do

    #     # xxxx tests that call something that resembles a functioning users#index
    #     it { should have_selector('h1', text: 'Map') }

    #   end

    # end

  end

	describe "About page" do

		before { visit about_path }

		it { should have_selector('h1', text: 'About') }
		it { should have_selector('title',
					text: full_title('About')) }
  
  end

  it "should have the right links on the layout" do
    visit root_path

    click_link "About"
    page.should have_selector 'title', text: full_title('About')

    ###### add more here ######
  end

end

