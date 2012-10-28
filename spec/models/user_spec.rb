require 'spec_helper'

describe User do

	before do

		@user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
						password: "foobar", password_confirmation: "foobar", lat: '50', lng: '0',
						status: "a" * 51, confirm_tac: true)
	end

	subject { @user }

  # Devise
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  # Linkedin
  it { should respond_to(:linkedin_uid) }
  it { should respond_to(:linkedin_token) }
  it { should respond_to(:linkedin_secret) }
  it { should respond_to(:headline) }
  it { should respond_to(:industry) }
  it { should respond_to(:picture_url) }
  it { should respond_to(:public_profile_url) }

  it { should respond_to(:admin) }
	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:lat) }
	it { should respond_to(:lng) }
	it { should respond_to(:skype) }
	it { should respond_to(:email_admin) }
	it { should respond_to(:email_users) }
	it { should respond_to(:confirm_tac) }
  it { should respond_to(:completed) }

	it { should respond_to(:status_approved) }
  it { should respond_to(:status) }

  it { should respond_to(:roulette_token) }
  it { should respond_to(:city) }
  it { should respond_to(:country) }

	### be_valid is the key test of all model validations
	it { should be_valid }
	it { should_not be_admin }

	# Name
  describe "when first_name is not present" do
    before { @user.first_name = " " }
    it { should_not be_valid }
  end

  describe "when last_name is not present" do
    before { @user.last_name = " " }
    it { should_not be_valid }
  end

  # Email

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w(user@foo,com user_at_foo.org example.user@foo.)
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # Password
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is blank" do
    before { @user.password_confirmation = '' }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  # Completed Profile
  describe "completed defaults to false" do
    before { @user.save }
    its(:completed) { should_not be_true }
  end

  # Approved
  describe "status approved defaults to false" do
    before { @user.save }
    its(:status_approved) { should_not be_true }
  end

  # Non-accessible Attributes
  describe "accessible attributes" do
    
    it "should not allow access to admin" do
      expect do
        User.new(admin: "1")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to completed" do
      expect do
        User.new(completed: "1")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to approved" do
      expect do
        User.new(status_approved: "1")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  # Error "can not update on a new record object" - seems reasonable, but lifted from MH...
  describe "with admin attribute set to 'true'" do
    before { @user.admin = true }
    it { should be_admin }
  end

  describe "with completed attribute set to 'true'" do
    before { @user.completed = true }
    it { should be_completed }
  end

  # Custom Attributes

  # Name
  describe "name should concatenate first_name and last_name" do
    before { @user.save }
    its(:name) { should eql "Example User" }
  end

  # Status Trunc
  describe "status truncated should be first 35 characters (until a space)" do
    before { @user.save }
    its(:status_trunc) { should eql "a" * 32 + "..." }
  end

  # Markers Array
  describe "markers" do

    before do
     15.times { FactoryGirl.create(:user) }
     15.times { FactoryGirl.create(:status_approved) }
    end

    it "should contain all user lat lng and id" do
      User.markers.should have(30).items
    end
  end

  # Approved & Unapproved Scopes

  # Do I need to test this? already checking model basis in test above (line 210)

  describe "approved scope" do

    before do
     15.times { FactoryGirl.create(:user) }
     15.times { FactoryGirl.create(:status_approved) }
    end

    it "should only contain approved users" do
      User.approved.should have(15).items
    end
  end


  # Search (using scoped_search gem)
  describe "searching" do

    before { FactoryGirl.create(:status_approved, first_name: "Idiot",
             last_name: "Retard", status: "z" * 51) }

    it 'looks for a users first name' do
      User.approved.search_for("Idiot").should have(1).item
    end

    it 'looks for a users last name' do
      User.approved.search_for("Retard").should have(1).item
    end

    it 'can search for just a substring AND looks for a users status' do
      User.approved.search_for("zzz").should have(1).item
    end
  end

  describe "filtering" do

    before do
      2.times { FactoryGirl.create(:user) }
      2.times { FactoryGirl.create(:status_approved, lat: 51.90155190493969, lng: -0.56060799360273) }
      2.times { FactoryGirl.create(:status_approved, lat: 46.7526281332615, lng: 7.96478263139727) }
    end

    it 'using list_global gives all results (approved and unapproved)' do
      User.list_global.count.should eql 6
    end

    # could do better test here, but only an order thing + might get rid of later
    it 'using list_rand gives all results (approved and unapproved)' do
      User.list_rand.count.should eql 6
    end

    it 'using list_local give results within 100km only' do
      User.list_local(51.9011282326659,-0.542411887645721).count.should eql 2
    end

  end

  describe "casecount" do

    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user, id: 2) }
    
    before do
      2.times do
        user_case = FactoryGirl.build(:case)
        user_case.user = user
        user_case.interviewer_id = 2
        user_case.save!
      end
    end

    it "case count should be correct" do
      user.case_count.should eql 2
    end

  end

end
