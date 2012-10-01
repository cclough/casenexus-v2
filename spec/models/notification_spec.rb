require 'spec_helper'

describe Notification do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @notification = user.notifications.build(sender_id: 2, 
    				        ntype: "message", content: "Some subject")

  end

  subject { @notification }

  it { should respond_to(:user_id) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:ntype) }
  it { should respond_to(:content) }
  it { should respond_to(:case_id) }
  it { should respond_to(:event_date) }
  it { should respond_to(:read) }

  # ?
  it { should respond_to(:user) }

  # ?
  its(:user) { should == user }

  it { should be_valid }


  describe "when user_id is not present" do
    before { @notification.user_id = nil }
    it { should_not be_valid }
  end

  describe "when sender_id is not present" do
    before { @notification.sender_id = nil }
    it { should_not be_valid }
  end

  describe "with blank subject" do
    before { @notification.ntype = " " }
    it { should_not be_valid }
  end


  describe "with ntype that is too long" do
    before { @notification.ntype = "a" * 21 }
    it { should_not be_valid }
  end


  describe "with content that is too long" do
    before { @notification.content = "a" * 501 }
    it { should_not be_valid }
  end


  describe "with blank content if ntype is message" do
    before do
      @notification.ntype = 'message'
      @notification.content = ""
    end
    it { should_not be_valid }
  end

  describe "with blank content if ntype is feedback_req" do
    before do
      @notification.ntype = 'feedback_req'
      @notification.content = ""
    end
    it { should_not be_valid }
  end

  describe "with blank content if ntype is feedback" do
    before do
      @notification.ntype = 'feedback'
      @notification.content = ""
    end
    it { should_not be_valid }
  end

  describe "with blank event_date if ntype is feedback_req" do
    before do
      @notification.ntype = 'feedback_req'
      @notification.event_date = ""
    end
    it { should_not be_valid }
  end

  describe "with blank event_date if ntype is feedback" do
    before do
      @notification.ntype = 'feedback'
      @notification.event_date = ""
    end
    it { should_not be_valid }
  end


  describe "sender should be user found by sender_id" do

    let(:user) { FactoryGirl.create(:user, id: 2) }

    before do
      @notification.save
    end

    its(:sender) { should == user }

  end

  describe "target should be user found by user_id" do

    before do
      @notification.save
    end

    its(:target) { should == user }

  end


  describe "header feed" do

    before do

      7.times { user.notifications.create(sender_id: 2, 
                ntype: "feedback_new", content: "Some subject", case_id: 5,
                event_date: Date.new(2012, 3, 3)) }

    end
    
    # No test for syntax of JSON, or that JSON is being made in controller

    it "should contain the correct number of data points" do
      Notification.header(user).should have(5).items
    end
  
    # it "should be ordered correctly" do
    #   # Notification.header(user)
    # end

  end

  describe "unread scope" do

    before do
      3.times { user.notifications.create(sender_id: 2, 
                ntype: "feedback_new", content: "Some subject", case_id: 5,
                event_date: Date.new(2012, 3, 3)) }

      5.times { user.notifications.create(sender_id: 2, 
                ntype: "feedback_new", content: "Some subject", case_id: 5,
                event_date: Date.new(2012, 3, 3),
                read: true) }
    end

    it "should only contain unread notifications" do
      # 3 + welcome notification = 4
      user.notifications.unread.should have(4).items
    end

  end

  describe "url should be correct depending on ntype" do

    let(:host) { "http://localhost:3000/" }

    before { @notification.save }

    its(:url) { should == host + "notifications/2" }



    it "welcome" do
      notification = user.notifications.create(sender_id: 2, 
                     ntype: "welcome")

      notification.url.should == host
    end

    it "feedback" do
      notification = user.notifications.create(sender_id: 2, 
                     ntype: "feedback", content: "Some subject",
                     case_id: 24, event_date: Date.new(2012, 3, 3))

      notification.url.should == host + "cases/24"
    end

    it "feedback_req" do
      notification = user.notifications.create(sender_id: 2, 
                     ntype: "feedback_req", content: "Some subject",
                     event_date: Date.new(2012, 3, 3))

      notification.url.should == host + "cases/new"
    end


  end

end