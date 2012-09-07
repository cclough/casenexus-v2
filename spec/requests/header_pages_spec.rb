require 'spec_helper'

describe "Header" do

  subject { page }

  describe "links lead to correct pages" do

	  let(:user) { FactoryGirl.create(:user) }
	  
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

	  # Case count here too?
	end

end