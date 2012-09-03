require 'spec_helper'

describe "Case Pages" do

	subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    

  	before(:each) do
      11.times { FactoryGirl.create(:user) }
      sign_in user
      visit cases_path
    end

    after(:all) do
      User.delete_all
    end

    it { should have_selector('title', text: 'Your Cases') }

    describe "pagination (& Global list selection)" do

      it { should have_selector('div.nexus_pagination') }

      it "should list each user" do
        
        user.cases.paginate(per_page: 10, page: 1).each do |c|
          page.should have_selector('strong', text: c.interviewer.name)
        end

      end
    end


  end
end