require 'spec_helper'

describe User do


	before do
		@user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
						password: "foobar", password_confirmation: "foobar", lat: '50', lng: '0',
						status: "a" * 51, accepts_tandc: true)
	end

	subject { @user }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:lat) }
	it { should respond_to(:lng) }
	it { should respond_to(:education1) }
	it { should respond_to(:education2) }
	it { should respond_to(:education3) }
	it { should respond_to(:experience1) }
	it { should respond_to(:experience2) }
	it { should respond_to(:experience3) }
	it { should respond_to(:education1_from) }
	it { should respond_to(:education2_from) }
	it { should respond_to(:education3_from) }
	it { should respond_to(:education1_to) }
	it { should respond_to(:education2_to) }
	it { should respond_to(:education3_to) }
	it { should respond_to(:experience1_from) }
	it { should respond_to(:experience2_from) }
	it { should respond_to(:experience3_from) }
	it { should respond_to(:experience1_to) }
	it { should respond_to(:experience2_to) }
	it { should respond_to(:experience3_to) }
	it { should respond_to(:skype) }
	it { should respond_to(:linkedin) }
	it { should respond_to(:email_admin) }
	it { should respond_to(:email_users) }
	it { should respond_to(:accepts_tandc) }
	it { should respond_to(:completed) }
  it { should respond_to(:approved) }
	it { should respond_to(:admin) }

	# not sure what this does yet
	it { should respond_to(:authenticate) }

	# all custom actions and relationships tested here (had_manys inc.)
	# it { should respond_to(:microposts) }

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

  describe "when first_name is too long" do
    before { @user.first_name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when last_name is too long" do
    before { @user.last_name = "a" * 31 }
    it { should_not be_valid }
  end


  # Email

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                  foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
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

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  # Remember Token
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


  # Location
  describe "when latitude is not present" do
    before { @user.lat = " " }
    it { should_not be_valid }
  end

  describe "when longitude is not present" do
    before { @user.lng = " " }
    it { should_not be_valid }
  end


  # Status
  describe "when status is not present" do
    before { @user.status = " " }
    it { should_not be_valid }
  end

  describe "when status is too long" do
    before { @user.status = "a" * 501  }
    it { should_not be_valid }
  end

  describe "when status is too short" do
    before { @user.status = "a" * 49 }
    it { should_not be_valid }
  end


  # Email Admin & Users
  describe "email_admin defaults to true" do
    before { @user.save }
    its(:email_admin) { should_not be_false }
  end

  describe "email_users defaults to true" do
    before { @user.save }
    its(:email_users) { should_not be_false }
  end


  # Completed Profile
  describe "completed defaults to false" do
    before { @user.save }
    its(:completed) { should_not be_true }
  end

  # Approved
  describe "approved defaults to false" do
    before { @user.save }
    its(:approved) { should_not be_true }
  end

  # Terms and Conditions
  describe "when Terms and Conditions have not been accepted" do
    before { @user.accepts_tandc = false }
    it { should_not be_valid }
  end



  # Non-accessible Attributes
  describe "accessible attributes" do
    
    it "should not allow access to admin" do
      expect do
        User.new(admin: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to completed" do
      expect do
        User.new(completed: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to approved" do
      expect do
        User.new(approved: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

  # Error "can not update on a new record object" - seems reasonable, but lifted from MH...
  # describe "with admin attribute set to 'true'" do
  #   before { @user.toggle!(:admin) }
  #   it { should be_admin }
  # end




end
